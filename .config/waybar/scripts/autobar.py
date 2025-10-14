#!/usr/bin/env python3
"""
Waybar-per-monitor auto-launcher for Hyprland.

What it does:
- Watches each monitor's active workspace.
- If the active workspace has at least one visible, mapped client, it starts a
  Waybar instance pinned to that monitor.
- If the workspace becomes empty, it stops that Waybar instance.
- Reacts to monitors being added/removed.
- Designed to run in the background (e.g., via Hyprland exec-once).

How it works (high-level):
- Polls `hyprctl -j monitors` and `hyprctl -j clients` about every 0.5s.
- Maps monitor -> active workspace -> number of visible, mapped clients.
- Starts/stops Waybar processes per monitor as needed.
- Uses a small per-monitor Waybar config that "includes" your base config and
  sets "output": ["<monitor-name>"].

Requirements:
- Waybar installed and discoverable in PATH.
- Hyprland (hyprctl must be available).
- Your Waybar base config at ~/.config/waybar/base.jsonc
- Your Waybar CSS at ~/.config/waybar/style.css
"""

# Standard library imports
import json  # For JSON parsing and writing
import os  # For environment variables and paths
import signal  # For clean shutdown on SIGINT/SIGTERM
import subprocess  # For running hyprctl and starting/stopping waybar
import time  # For sleeping between polls
from pathlib import Path  # For convenient filesystem path handling
from typing import Dict, List, Set  # For type hints

# The Waybar executable name (assumes it is in PATH)
WAYBAR_BIN = "waybar"

# Path to your base Waybar config (should NOT specify "output")
BASE_CONFIG = Path.home() / ".config/waybar/config.jsonc"

# Path to your Waybar CSS stylesheet
STYLE_CSS = Path.home() / ".config/waybar/style.css"

# Directory to store generated per-monitor Waybar wrapper configs
CACHE_DIR = Path.home() / ".cache/autobar"

# How often (in seconds) to poll Hyprland for state changes
POLL_INTERVAL_SEC = 0.5

# A mapping of monitor name -> running Waybar Popen process
procs: Dict[str, subprocess.Popen] = {}


def run_json(args: List[str]):
    """
    Run a command that prints JSON and return the parsed object.
    Returns None on any error (command failure or JSON decode error).
    """
    try:
        # Execute command and capture stdout as text
        out = subprocess.check_output(args, text=True)
        # Parse and return JSON
        return json.loads(out)
    except Exception:
        # On any error (e.g., hyprctl unavailable), return None
        return None


def get_monitors():
    """
    Get a list of active (non-disabled) monitors from Hyprland.
    Returns an empty list on error.
    """
    # Ask Hyprland for monitor info in JSON
    data = run_json(["hyprctl", "-j", "monitors"])
    if not data:
        # If hyprctl failed or returned empty, return empty list
        return []
    # Collect non-disabled monitors (be tolerant of field differences)
    mons = []
    for m in data:
        # Skip monitors that are marked disabled
        if m.get("disabled") is True:
            continue
        # Keep everything else
        mons.append(m)
    return mons


def get_clients():
    """
    Get the list of all clients (windows) known to Hyprland.
    Returns an empty list on error.
    """
    # Query clients via hyprctl
    data = run_json(["hyprctl", "-j", "clients"])
    if not data:
        # Return empty list if failed
        return []
    return data


def monitors_needing_waybar() -> Set[str]:
    """
    Determine which monitors currently need Waybar visible.
    A monitor "needs" Waybar if the active workspace on that monitor has
    at least one client that is mapped and not hidden.
    Returns a set of monitor names that need Waybar.
    """
    # Get current monitors
    mons = get_monitors()
    # Get current clients (windows)
    clients = get_clients()

    # Build a mapping: monitor name -> active workspace id
    ws_by_mon: Dict[str, int] = {}
    for m in mons:
        # Active workspace info is an object; get it safely
        aw = m.get("activeWorkspace") or {}
        # Workspace numeric id
        wsid = aw.get("id")
        # Monitor name; fall back to description or id if needed
        name = m.get("name") or m.get("description") or str(m.get("id"))
        # Only map if both fields exist
        if wsid is not None and name:
            ws_by_mon[name] = wsid

    # Count visible, mapped clients per workspace id
    counts_by_ws: Dict[int, int] = {}
    for c in clients:
        # Determine which workspace this client is on
        ws = (c.get("workspace") or {}).get("id")
        if ws is None:
            # Skip clients without a workspace id
            continue
        # Skip clients that are not mapped (not actually shown)
        if not c.get("mapped", False):
            continue
        # Skip hidden clients (e.g., minimized or special states)
        if c.get("hidden", False):
            continue
        # Increment the visible client count for this workspace
        counts_by_ws[ws] = counts_by_ws.get(ws, 0) + 1

    # Compute which monitors need Waybar based on counts
    need: Set[str] = set()
    for mon_name, wsid in ws_by_mon.items():
        # If active workspace has at least one visible client, Waybar is needed
        if counts_by_ws.get(wsid, 0) > 0:
            need.add(mon_name)
    return need


def ensure_monitor_config(mon_name: str) -> Path:
    """
    Create (or update) a small Waybar config that includes the base config and
    pins Waybar to a specific monitor via the "output" field.
    Returns the path to the generated config file.
    """
    # Make sure cache dir exists
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    # Path for this monitor's wrapper config
    cfg = CACHE_DIR / f"waybar-{mon_name}.jsonc"
    # Minimal wrapper config pointing to your base file and this monitor output
    content = {
        # Waybar supports "include" to merge another JSON config
        "include": str(BASE_CONFIG),
        # Restrict this Waybar instance to a single monitor by name
        "output": [mon_name],
    }
    # Write atomically: write to tmp and then replace target file
    tmp = cfg.with_suffix(".tmp")
    # Dump JSON with indentation for readability
    tmp.write_text(json.dumps(content, indent=2))
    # Atomically move temp file into place
    tmp.replace(cfg)
    # Return the path to the config we just created/updated
    return cfg


def start_waybar_for(mon_name: str):
    """
    Start a Waybar instance for the given monitor if not already running.
    """
    # If a process exists for this monitor and is still running, do nothing
    if mon_name in procs and procs[mon_name].poll() is None:
        return
    # Ensure we have a per-monitor config ready
    cfg = ensure_monitor_config(mon_name)
    # Copy current environment so Waybar inherits necessary variables
    env = os.environ.copy()
    # Reduce Waybar log noise; you can remove this if you want logs
    env.setdefault("WAYBAR_LOG_LEVEL", "error")
    # Launch Waybar with the per-monitor config and your style.css
    p = subprocess.Popen(
        [WAYBAR_BIN, "-c", str(cfg), "-s", str(STYLE_CSS)],
        env=env,
        stdout=subprocess.DEVNULL,  # Silence stdout (optional)
        stderr=subprocess.DEVNULL,  # Silence stderr (optional)
        start_new_session=True,  # Detach from this Python process group
    )
    # Record the process handle keyed by monitor name
    procs[mon_name] = p


def stop_waybar_for(mon_name: str):
    """
    Stop the Waybar instance for the given monitor if it is running.
    """
    # Look up the process for this monitor
    p = procs.get(mon_name)
    if not p:
        # Nothing to stop
        return
    # If the process is still alive, terminate it gracefully
    if p.poll() is None:
        try:
            # Ask Waybar to exit
            p.terminate()
            # Wait a short while for clean shutdown
            for _ in range(20):
                if p.poll() is not None:
                    break
                time.sleep(0.05)
            # If it still hasn't exited, force kill
            if p.poll() is None:
                p.kill()
        except Exception:
            # Ignore any errors during shutdown
            pass
    # Remove from our process tracking dict
    procs.pop(mon_name, None)


def reconcile():
    """
    Core loop step:
    - Decide which monitors need Waybar.
    - Start Waybar where needed.
    - Stop Waybar where not needed or where the monitor disappeared.
    - Clean up any dead processes we may have missed.
    """
    # Determine the set of monitor names that should have Waybar now
    needed = monitors_needing_waybar()

    # Stop Waybar for monitors that no longer need it (or no longer exist)
    for mon_name in list(procs.keys()):
        if mon_name not in needed:
            stop_waybar_for(mon_name)

    # Start Waybar for monitors that now need it
    for mon_name in needed:
        start_waybar_for(mon_name)

    # Clean up any entries where the process has already exited
    for mon_name, p in list(procs.items()):
        if p.poll() is not None:
            procs.pop(mon_name, None)


def main():
    """
    Entry point: verify base config exists, then enter the polling loop.
    """
    # If the base config is missing, do not run (prevents spammy failures)
    if not BASE_CONFIG.exists():
        print(f"Missing base Waybar config at {BASE_CONFIG}", flush=True)
        return

    # Main polling loop, runs indefinitely
    while True:
        try:
            # Perform one reconciliation cycle
            reconcile()
        except Exception:
            # On transient errors (e.g., during Hyprland reload), back off a bit
            time.sleep(1.0)
        # Sleep until next poll to reduce CPU usage
        time.sleep(POLL_INTERVAL_SEC)


def _shutdown(signum, frame):
    """
    Signal handler to stop all Waybar instances cleanly before exit.
    """
    # Iterate a copy of keys to avoid modifying during iteration
    for mon in list(procs.keys()):
        stop_waybar_for(mon)
    # Exit the process
    raise SystemExit


# Only run main when the script is executed directly (not imported)
if __name__ == "__main__":
    # Register signal handlers for Ctrl+C (SIGINT) and system stop (SIGTERM)
    signal.signal(signal.SIGINT, _shutdown)
    signal.signal(signal.SIGTERM, _shutdown)
    # Start the daemon
    main()
