#!/usr/bin/env python3
"""
Waybar MPRIS Media Player Popup
--------------------------------
A GTK4 popup showing album art, track info, play/pause, next/prev, and seekbar.
Triggered by clicking the MPRIS module in Waybar.

Dependencies:
  - python-gobject (pygobject)
  - gtk4
  - playerctl
  - python-dbus (dbus-python)

Usage:
  chmod +x mediaplayer-popup.py
  ./mediaplayer-popup.py [--toggle]   # --toggle closes if already open
"""

import gi
gi.require_version("Gtk", "4.0")
gi.require_version("GdkPixbuf", "2.0")

import os
import sys
import signal
import subprocess
import threading
import tempfile
import urllib.request
from pathlib import Path

from gi.repository import Gtk, GLib, GdkPixbuf, Gio, Gdk, Pango

# Try to import GdkX11 / GdkWayland for keep-above hints (optional)
_gdk_x11 = None
try:
    gi.require_version("GdkX11", "4.0")
    from gi.repository import GdkX11 as _gdk_x11
except Exception:
    pass

# ─── Config ────────────────────────────────────────────────────────────────────
LOCK_FILE   = "/tmp/waybar-mediaplayer-popup.lock"
WINDOW_W    = 340
WINDOW_H    = 440
SEEK_INTERVAL_MS = 500   # how often the seekbar updates (ms)
# ───────────────────────────────────────────────────────────────────────────────


def playerctl(*args) -> str:
    """Run playerctl and return stdout, or '' on error."""
    try:
        result = subprocess.run(
            ["playerctl", *args],
            capture_output=True, text=True, timeout=2
        )
        return result.stdout.strip()
    except Exception:
        return ""


def get_metadata() -> dict:
    fmt = (
        "{{artist}}\n{{title}}\n{{album}}\n"
        "{{mpris:artUrl}}\n{{mpris:length}}\n{{status}}"
    )
    raw = playerctl("metadata", "--format", fmt)
    lines = (raw + "\n" * 6).split("\n")
    return {
        "artist":   lines[0] or "Unknown Artist",
        "title":    lines[1] or "Unknown Title",
        "album":    lines[2] or "",
        "art_url":  lines[3] or "",
        "length":   int(lines[4]) // 1_000_000 if lines[4].isdigit() else 0,
        "status":   lines[5] or "Stopped",
    }


def get_position() -> float:
    """Return current position in seconds."""
    raw = playerctl("position")
    try:
        return float(raw)
    except ValueError:
        return 0.0


def fetch_art(url: str) -> GdkPixbuf.Pixbuf | None:
    """Fetch album art from a URL or file:// path, return a Pixbuf."""
    if not url:
        return None
    try:
        if url.startswith("file://"):
            path = url[7:]
            return GdkPixbuf.Pixbuf.new_from_file_at_scale(path, 200, 200, True)
        # Remote URL – download to a temp file
        with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as f:
            urllib.request.urlretrieve(url, f.name)
            pix = GdkPixbuf.Pixbuf.new_from_file_at_scale(f.name, 200, 200, True)
            os.unlink(f.name)
            return pix
    except Exception:
        return None


def seconds_to_mmss(s: float) -> str:
    s = max(0, int(s))
    return f"{s // 60}:{s % 60:02d}"


# ─── CSS ───────────────────────────────────────────────────────────────────────
CSS = b"""
window {
    background-color: #0d0d12;
    border-radius: 16px;
    border: 1px solid rgba(255,255,255,0.08);
}

.popup-root {
    background: transparent;
    padding: 0;
}

.art-container {
    background: #16161f;
    border-radius: 12px;
    margin: 16px 16px 0 16px;
}

.art-placeholder {
    background: linear-gradient(135deg, #1e1e2e, #2a2a3e);
    min-height: 200px;
}

.art-placeholder label {
    font-size: 64px;
}

.art-image {
    border-radius: 12px;
}

.info-box {
    padding: 14px 16px 4px 16px;
}

.track-title {
    font-family: "DM Sans", "Cantarell", sans-serif;
    font-size: 16px;
    font-weight: 700;
    color: #f0f0f8;
    margin-bottom: 2px;
}

.track-artist {
    font-family: "DM Sans", "Cantarell", sans-serif;
    font-size: 12px;
    font-weight: 400;
    color: rgba(180,180,210,0.7);
}

.track-album {
    font-family: "DM Sans", "Cantarell", sans-serif;
    font-size: 11px;
    color: rgba(140,140,180,0.5);
    margin-top: 1px;
}

.seek-area {
    padding: 12px 16px 2px 16px;
}

scale {
    color: #7c6af7;
}

scale trough {
    background-color: rgba(255,255,255,0.1);
    border-radius: 4px;
    min-height: 4px;
}

scale highlight {
    background-color: #7c6af7;
    border-radius: 4px;
}

scale slider {
    background-color: #fff;
    border-radius: 50%;
    min-width: 12px;
    min-height: 12px;
    margin: -4px;
    box-shadow: 0 0 6px rgba(124,106,247,0.8);
}

.time-row {
    padding: 0 18px;
}

.time-label {
    font-family: "JetBrains Mono", "Monospace", monospace;
    font-size: 10px;
    color: rgba(160,160,200,0.5);
}

.controls-row {
    padding: 8px 16px 14px 16px;
}

.ctrl-btn {
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.07);
    border-radius: 50%;
    min-width: 44px;
    min-height: 44px;
    color: rgba(200,200,230,0.9);
    transition: background 150ms ease, color 150ms ease;
}

.ctrl-btn:hover {
    background: rgba(124,106,247,0.25);
    color: #fff;
    border-color: rgba(124,106,247,0.5);
}

.ctrl-btn:active {
    background: rgba(124,106,247,0.45);
}

.play-btn {
    background: #7c6af7;
    border: none;
    border-radius: 50%;
    min-width: 54px;
    min-height: 54px;
    color: #fff;
    transition: background 150ms ease, box-shadow 150ms ease;
    box-shadow: 0 4px 18px rgba(124,106,247,0.45);
}

.play-btn:hover {
    background: #9580ff;
    box-shadow: 0 4px 24px rgba(124,106,247,0.65);
}

.play-btn:active {
    background: #5e4ed4;
}

.close-btn {
    background: transparent;
    border: none;
    color: rgba(160,160,200,0.4);
    padding: 2px 6px;
    border-radius: 6px;
}

.close-btn:hover {
    color: rgba(200,200,230,0.9);
    background: rgba(255,255,255,0.07);
}
"""


# ─── Main Window ───────────────────────────────────────────────────────────────
class MediaPopup(Gtk.ApplicationWindow):

    def __init__(self, app):
        super().__init__(application=app)

        self.set_title("Media Player")
        self.set_default_size(WINDOW_W, WINDOW_H)
        self.set_resizable(False)

        # Remove window decorations
        self.set_decorated(False)

        # Keep on top — GTK4 removed set_keep_above(); use realize signal
        # to apply the hint via the native surface after the window is mapped.
        self.connect("realize", self._on_realize)

        self._seek_dragging = False
        self._meta = {}
        self._seek_timer_id = None

        self._build_ui()
        self._refresh()

        # Keyboard: Escape closes
        key_ctrl = Gtk.EventControllerKey()
        key_ctrl.connect("key-pressed", self._on_key)
        self.add_controller(key_ctrl)

        # Click outside → close  (focus-out)
        self.connect("notify::is-active", self._on_focus_change)

    # ── UI Construction ────────────────────────────────────────────────────────

    def _on_realize(self, widget):
        """Apply keep-above hint once the native surface exists (X11 only)."""
        if _gdk_x11 is None:
            return
        surface = self.get_surface()
        if surface and isinstance(surface, _gdk_x11.X11Surface):
            try:
                xdisplay = _gdk_x11.X11Display.get_default()
                # Use wmctrl-style _NET_WM_STATE_ABOVE via Xlib atom approach
                # Simplest: just call the GdkX11 surface method if available
                surface.set_utf8_property("_NET_WM_STATE", "_NET_WM_STATE_ABOVE")
            except Exception:
                pass

    def _build_ui(self):
        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        root.add_css_class("popup-root")
        self.set_child(root)

        # ── Header bar (close button) ──────────────────────────────────────────
        header = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        header.set_margin_top(10)
        header.set_margin_end(10)
        header.set_hexpand(True)

        spacer = Gtk.Label()
        spacer.set_hexpand(True)
        header.append(spacer)

        close_btn = Gtk.Button(label="✕")
        close_btn.add_css_class("close-btn")
        close_btn.connect("clicked", lambda *_: self.close())
        header.append(close_btn)
        root.append(header)

        # ── Album art ─────────────────────────────────────────────────────────
        self._art_container = Gtk.Box()
        self._art_container.add_css_class("art-container")
        self._art_container.set_halign(Gtk.Align.FILL)
        self._art_container.set_size_request(WINDOW_W - 32, 200)

        self._art_image = Gtk.Picture()
        self._art_image.add_css_class("art-image")
        self._art_image.set_can_shrink(True)
        self._art_image.set_size_request(WINDOW_W - 32, 200)

        self._art_placeholder = Gtk.Box()
        self._art_placeholder.add_css_class("art-placeholder")
        self._art_placeholder.set_size_request(WINDOW_W - 32, 200)
        ph_label = Gtk.Label(label="🎵")
        ph_label.set_hexpand(True)
        ph_label.set_vexpand(True)
        ph_label.set_halign(Gtk.Align.CENTER)
        ph_label.set_valign(Gtk.Align.CENTER)
        self._art_placeholder.append(ph_label)

        self._art_container.append(self._art_placeholder)
        root.append(self._art_container)

        # ── Track info ────────────────────────────────────────────────────────
        info_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        info_box.add_css_class("info-box")

        self._title_label = Gtk.Label(label="Nothing Playing")
        self._title_label.add_css_class("track-title")
        self._title_label.set_halign(Gtk.Align.START)
        self._title_label.set_ellipsize(Pango.EllipsizeMode.END)
        self._title_label.set_max_width_chars(32)
        info_box.append(self._title_label)

        self._artist_label = Gtk.Label(label="—")
        self._artist_label.add_css_class("track-artist")
        self._artist_label.set_halign(Gtk.Align.START)
        self._artist_label.set_ellipsize(Pango.EllipsizeMode.END)
        self._artist_label.set_max_width_chars(38)
        info_box.append(self._artist_label)

        self._album_label = Gtk.Label(label="")
        self._album_label.add_css_class("track-album")
        self._album_label.set_halign(Gtk.Align.START)
        self._album_label.set_ellipsize(Pango.EllipsizeMode.END)
        self._album_label.set_max_width_chars(38)
        info_box.append(self._album_label)

        root.append(info_box)

        # ── Seek bar ──────────────────────────────────────────────────────────
        seek_area = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        seek_area.add_css_class("seek-area")

        self._seek_adj = Gtk.Adjustment(value=0, lower=0, upper=100,
                                        step_increment=1, page_increment=10)
        self._seek_scale = Gtk.Scale(orientation=Gtk.Orientation.HORIZONTAL,
                                     adjustment=self._seek_adj)
        self._seek_scale.set_draw_value(False)
        self._seek_scale.set_hexpand(True)
        # GTK4: use GestureClick instead of button-press/release-event signals
        drag_start = Gtk.GestureClick()
        drag_start.connect("pressed", lambda *_: self._set_dragging(True))
        drag_start.connect("released", self._on_seek_gesture_release)
        self._seek_scale.add_controller(drag_start)

        seek_area.append(self._seek_scale)
        root.append(seek_area)

        # ── Time labels ───────────────────────────────────────────────────────
        time_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        time_row.add_css_class("time-row")
        time_row.set_hexpand(True)

        self._pos_label = Gtk.Label(label="0:00")
        self._pos_label.add_css_class("time-label")
        self._pos_label.set_halign(Gtk.Align.START)
        self._pos_label.set_hexpand(True)

        self._dur_label = Gtk.Label(label="0:00")
        self._dur_label.add_css_class("time-label")
        self._dur_label.set_halign(Gtk.Align.END)

        time_row.append(self._pos_label)
        time_row.append(self._dur_label)
        root.append(time_row)

        # ── Controls ──────────────────────────────────────────────────────────
        ctrl_row = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        ctrl_row.add_css_class("controls-row")
        ctrl_row.set_halign(Gtk.Align.CENTER)
        ctrl_row.set_spacing(14)

        prev_btn = Gtk.Button(label="⏮")
        prev_btn.add_css_class("ctrl-btn")
        prev_btn.connect("clicked", lambda *_: playerctl("previous"))

        self._play_btn = Gtk.Button(label="⏸")
        self._play_btn.add_css_class("play-btn")
        self._play_btn.connect("clicked", self._on_play_pause)

        next_btn = Gtk.Button(label="⏭")
        next_btn.add_css_class("ctrl-btn")
        next_btn.connect("clicked", lambda *_: playerctl("next"))

        ctrl_row.append(prev_btn)
        ctrl_row.append(self._play_btn)
        ctrl_row.append(next_btn)
        root.append(ctrl_row)

    # ── Logic ──────────────────────────────────────────────────────────────────

    def _set_dragging(self, val: bool):
        self._seek_dragging = val

    def _on_seek_gesture_release(self, gesture, n_press, x, y):
        self._seek_dragging = False
        pos = self._seek_adj.get_value()
        playerctl("position", str(pos))

    def _on_play_pause(self, *_):
        playerctl("play-pause")
        GLib.timeout_add(120, self._refresh)

    def _on_key(self, ctrl, keyval, keycode, state):
        if keyval == Gdk.KEY_Escape:
            self.close()
            return True
        return False

    def _on_focus_change(self, window, param):
        if not self.is_active():
            # small delay so clicks on the popup itself don't dismiss it
            GLib.timeout_add(200, self._check_close)

    def _check_close(self):
        if not self.is_active():
            self.close()
        return False

    def _refresh(self):
        """Pull metadata and update the UI."""
        def worker():
            meta = get_metadata()
            art_url = meta.get("art_url", "")
            pixbuf = fetch_art(art_url)
            GLib.idle_add(self._apply_metadata, meta, pixbuf)

        threading.Thread(target=worker, daemon=True).start()

        # Start the seek updater
        if self._seek_timer_id is None:
            self._seek_timer_id = GLib.timeout_add(SEEK_INTERVAL_MS, self._update_seek)

        return False  # don't repeat via GLib

    def _apply_metadata(self, meta: dict, pixbuf):
        self._meta = meta

        self._title_label.set_text(meta["title"])
        self._artist_label.set_text(meta["artist"])
        self._album_label.set_text(meta["album"])

        status = meta["status"]
        self._play_btn.set_label("⏸" if status == "Playing" else "▶")

        length = meta["length"]
        self._seek_adj.set_upper(max(length, 1))
        self._dur_label.set_text(seconds_to_mmss(length))

        # Album art
        if pixbuf:
            # Remove placeholder, show image
            child = self._art_container.get_first_child()
            if child:
                self._art_container.remove(child)
            texture = Gdk.Texture.new_for_pixbuf(pixbuf)
            self._art_image.set_paintable(texture)
            self._art_container.append(self._art_image)
        else:
            child = self._art_container.get_first_child()
            if child and child != self._art_placeholder:
                self._art_container.remove(child)
                self._art_container.append(self._art_placeholder)

        return False

    def _update_seek(self) -> bool:
        """Called every SEEK_INTERVAL_MS to update the seekbar position."""
        if not self._seek_dragging:
            pos = get_position()
            self._seek_adj.set_value(pos)
            self._pos_label.set_text(seconds_to_mmss(pos))

        status = playerctl("status")
        self._play_btn.set_label("⏸" if status == "Playing" else "▶")

        return True  # keep repeating


# ─── Application ───────────────────────────────────────────────────────────────
class MediaApp(Gtk.Application):

    def __init__(self):
        super().__init__(
            application_id="com.github.waybar.mediaplayer",
            flags=Gio.ApplicationFlags.FLAGS_NONE,
        )

    def do_activate(self):
        # Apply CSS
        provider = Gtk.CssProvider()
        provider.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_display(
            Gdk.Display.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
        )

        win = MediaPopup(self)
        win.present()


def already_running() -> bool:
    """Return True if a popup is already open (via lock file)."""
    if os.path.exists(LOCK_FILE):
        try:
            pid = int(Path(LOCK_FILE).read_text().strip())
            os.kill(pid, 0)   # check if PID is alive
            return True
        except (ValueError, ProcessLookupError, PermissionError):
            pass
    return False


def kill_existing():
    if os.path.exists(LOCK_FILE):
        try:
            pid = int(Path(LOCK_FILE).read_text().strip())
            os.kill(pid, signal.SIGTERM)
        except Exception:
            pass
        os.unlink(LOCK_FILE)


def write_lock():
    Path(LOCK_FILE).write_text(str(os.getpid()))


def cleanup_lock():
    if os.path.exists(LOCK_FILE):
        try:
            os.unlink(LOCK_FILE)
        except Exception:
            pass


# ─── Entry point ───────────────────────────────────────────────────────────────
if __name__ == "__main__":
    toggle = "--toggle" in sys.argv

    if toggle and already_running():
        kill_existing()
        sys.exit(0)

    write_lock()
    signal.signal(signal.SIGTERM, lambda *_: (cleanup_lock(), sys.exit(0)))
    signal.signal(signal.SIGINT,  lambda *_: (cleanup_lock(), sys.exit(0)))

    app = MediaApp()
    try:
        app.run(None)
    finally:
        cleanup_lock()
