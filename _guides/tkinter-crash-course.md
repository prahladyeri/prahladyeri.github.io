---
layout: page
title: "Tkinter Crash Course: Desktop Development with Python"
order: 2
date: 2026-06-15
---

> A comprehensive guide from basic GUIs to modern web-wrapper apps, multi-threading, and distribution.

{% assign words = page.content | number_of_words %}
**Prahlad Yeri** · June 15, 2026 · {% if words < 360 %}1 min{% else %}{{ words | divided_by: 180 }} min{% endif %} read

> **Note:** This article was written with AI assistance.

---

## Table of Contents

1. [Introduction & Setup](#1-introduction--setup)
2. [Core Concepts: Windows, Geometry, and Layout](#2-core-concepts-windows-geometry-and-layout)
3. [Essential Widgets](#3-essential-widgets)
4. [Advanced Widgets](#4-advanced-widgets)
5. [Styling with ttk and Themes](#5-styling-with-ttk-and-themes)
6. [Event Handling & Bindings](#6-event-handling--bindings)
7. [Dialogs, Menus, and System Tray](#7-dialogs-menus-and-system-tray)
8. [Multi-threading & Responsiveness](#8-multi-threading--responsiveness)
9. [Data Persistence: SQLite, JSON, Config Files](#9-data-persistence-sqlite-json-config-files)
10. [Modern HTML Apps with Web Wrappers](#10-modern-html-apps-with-web-wrappers)
11. [Packaging & Distribution](#11-packaging--distribution)
12. [Real-World Project: A Full Task Manager App](#12-real-world-project-a-full-task-manager-app)

---

## 1. Introduction & Setup

### Why Tkinter?

Tkinter is Python's standard GUI library — it ships with CPython on all platforms (Windows, macOS, Linux) with zero extra installation. It wraps Tcl/Tk and gives you:

- **Zero dependencies** for basic apps
- **Cross-platform** native-ish look
- **Simple mental model** — widgets, geometry managers, event loop
- **Fast prototyping** — a working window in 5 lines

It's not the flashiest toolkit, but combined with modern approaches (ttk themes, web wrappers, custom styling) it's capable of shipping real-world desktop apps.

### Installation Check

```python
import tkinter as tk
print(tk.TkVersion)   # Should print 8.6 or higher
tk.Tk().mainloop()    # Opens a blank window
```

If you're on Linux and tkinter isn't installed:

```bash
# Ubuntu/Debian
sudo apt install python3-tk

# Fedora/RHEL
sudo dnf install python3-tkinter
```

### Project Structure Convention

```
my_app/
├── main.py              # Entry point
├── app.py               # Root App class
├── views/               # Individual screen/panel classes
│   ├── main_view.py
│   └── settings_view.py
├── models/              # Data / business logic
│   └── task_model.py
├── assets/              # Icons, images
│   └── icon.ico
├── requirements.txt
└── build.spec           # PyInstaller spec (later)
```

---

## 2. Core Concepts: Windows, Geometry, and Layout

### The Root Window

```python
import tkinter as tk

root = tk.Tk()
root.title("My App")
root.geometry("800x600")        # WIDTHxHEIGHT
root.geometry("800x600+100+50") # ...+X_OFFSET+Y_OFFSET
root.minsize(400, 300)
root.maxsize(1920, 1080)
root.resizable(True, False)     # (width_resizable, height_resizable)

# App icon (use .ico on Windows, .png on Linux/macOS)
root.iconbitmap("assets/icon.ico")       # Windows
# root.iconphoto(True, tk.PhotoImage(file="assets/icon.png"))  # Cross-platform

root.mainloop()  # Starts the event loop — blocks until window closes
```

### The Three Geometry Managers

You must use exactly ONE geometry manager per container. Never mix `pack` and `grid` in the same parent.

#### pack — Simple linear layout

```python
import tkinter as tk

root = tk.Tk()

btn1 = tk.Button(root, text="Top")
btn1.pack(side=tk.TOP, fill=tk.X, padx=10, pady=5)

btn2 = tk.Button(root, text="Left")
btn2.pack(side=tk.LEFT, fill=tk.Y)

btn3 = tk.Button(root, text="Right")
btn3.pack(side=tk.RIGHT)

# fill options: tk.X, tk.Y, tk.BOTH, tk.NONE
# expand=True: widget takes extra space
label = tk.Label(root, text="Center", bg="lightblue")
label.pack(fill=tk.BOTH, expand=True)

root.mainloop()
```

#### grid — Table layout (most powerful)

```python
import tkinter as tk

root = tk.Tk()
root.columnconfigure(1, weight=1)  # Column 1 expands with window

tk.Label(root, text="Name:").grid(row=0, column=0, sticky="e", padx=5, pady=5)
name_entry = tk.Entry(root)
name_entry.grid(row=0, column=1, sticky="ew", padx=5, pady=5)

tk.Label(root, text="Email:").grid(row=1, column=0, sticky="e", padx=5, pady=5)
email_entry = tk.Entry(root)
email_entry.grid(row=1, column=1, sticky="ew", padx=5, pady=5)

# sticky: "n", "s", "e", "w", "ns", "ew", "nsew" (cardinal directions / fill)
# columnspan / rowspan for merged cells
tk.Button(root, text="Submit").grid(row=2, column=0, columnspan=2, pady=10)

root.mainloop()
```

#### place — Absolute/relative positioning

```python
# Use sparingly — doesn't resize well
btn = tk.Button(root, text="Centered")
btn.place(relx=0.5, rely=0.5, anchor="center")  # 50% from top-left
```

### Frame — The Layout Container

`Frame` is the key to complex layouts. Each frame can use its own geometry manager.

```python
import tkinter as tk

root = tk.Tk()
root.geometry("600x400")

# Sidebar
sidebar = tk.Frame(root, bg="#2c3e50", width=150)
sidebar.pack(side=tk.LEFT, fill=tk.Y)
sidebar.pack_propagate(False)  # Prevent frame from shrinking to content

# Main content area
content = tk.Frame(root, bg="white")
content.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

# Widgets inside sidebar use sidebar as parent
tk.Label(sidebar, text="Menu", bg="#2c3e50", fg="white",
         font=("Arial", 12, "bold")).pack(pady=20)
for item in ["Dashboard", "Tasks", "Settings"]:
    tk.Button(sidebar, text=item, bg="#34495e", fg="white",
              relief=tk.FLAT, pady=8).pack(fill=tk.X)

tk.Label(content, text="Welcome!", font=("Arial", 24)).pack(pady=50)

root.mainloop()
```

### Toplevel — Child Windows

```python
def open_window():
    win = tk.Toplevel(root)
    win.title("Settings")
    win.geometry("400x300")
    win.grab_set()  # Makes it modal (blocks parent)
    win.transient(root)  # Keeps it on top of parent

btn = tk.Button(root, text="Open Settings", command=open_window)
btn.pack()
```

---

## 3. Essential Widgets

### Label

```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()

# Basic label
lbl = tk.Label(root, text="Hello World",
               font=("Helvetica", 16, "bold"),
               fg="#333333", bg="white",
               wraplength=200,         # Word-wrap at 200px
               justify=tk.LEFT)
lbl.pack(padx=20, pady=10)

# With image
img = tk.PhotoImage(file="icon.png")
img_label = tk.Label(root, image=img, text="Icon + Text",
                     compound=tk.LEFT)  # Image left of text
img_label.pack()

# Dynamic update
lbl.config(text="Updated!")
lbl["text"] = "Also works"

root.mainloop()
```

### Button

```python
import tkinter as tk

root = tk.Tk()

def on_click():
    print("Clicked!")

# Standard button
btn = tk.Button(root, text="Click Me",
                command=on_click,
                bg="#3498db", fg="white",
                font=("Arial", 11),
                padx=15, pady=8,
                relief=tk.FLAT,
                cursor="hand2",          # Pointer cursor on hover
                activebackground="#2980b9",
                activeforeground="white")
btn.pack(pady=10)

# Disable / enable
btn.config(state=tk.DISABLED)
btn.config(state=tk.NORMAL)

# Toggle button pattern
is_active = tk.BooleanVar(value=False)

def toggle():
    is_active.set(not is_active.get())
    toggle_btn.config(
        text="ON" if is_active.get() else "OFF",
        bg="#2ecc71" if is_active.get() else "#e74c3c"
    )

toggle_btn = tk.Button(root, text="OFF", command=toggle,
                       bg="#e74c3c", fg="white", width=6)
toggle_btn.pack()

root.mainloop()
```

### Entry (Single-line Text Input)

```python
import tkinter as tk

root = tk.Tk()

# Basic entry with StringVar
name_var = tk.StringVar()
entry = tk.Entry(root, textvariable=name_var,
                 font=("Arial", 12),
                 width=30,
                 relief=tk.FLAT,
                 bg="#f0f0f0")
entry.pack(padx=20, pady=10)
entry.insert(0, "Placeholder text")   # Initial text
entry.focus()                          # Auto-focus

# Password field
pwd = tk.Entry(root, show="*", font=("Arial", 12))
pwd.pack(padx=20, pady=5)

# Trace changes
def on_change(*args):
    print(f"Value: {name_var.get()}")

name_var.trace_add("write", on_change)

# Read / clear
value = entry.get()
entry.delete(0, tk.END)

root.mainloop()
```

### Text (Multi-line)

```python
import tkinter as tk

root = tk.Tk()

# Scrolled text area
frame = tk.Frame(root)
frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

text = tk.Text(frame, font=("Courier", 11),
               wrap=tk.WORD,          # tk.NONE, tk.CHAR, tk.WORD
               undo=True,
               maxundo=50,
               relief=tk.FLAT,
               bg="#1e1e1e", fg="#d4d4d4",
               insertbackground="white")   # Cursor color
text.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

scrollbar = tk.Scrollbar(frame, command=text.yview)
scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
text.config(yscrollcommand=scrollbar.set)

# Insert / get / delete
text.insert(tk.END, "Line 1\nLine 2\n")
text.insert("1.0", "Prepended\n")     # "line.col" indexing

content = text.get("1.0", tk.END)    # Get all text
text.delete("1.0", tk.END)           # Clear all

# Tags for syntax highlighting / styling
text.tag_configure("keyword", foreground="#569cd6", font=("Courier", 11, "bold"))
text.insert(tk.END, "def ")
text.tag_add("keyword", "end-5c", "end-1c")

# Read-only mode
text.config(state=tk.DISABLED)
# To write to disabled widget:
text.config(state=tk.NORMAL)
text.insert(tk.END, "...")
text.config(state=tk.DISABLED)

root.mainloop()
```

### Checkbutton and Radiobutton

```python
import tkinter as tk

root = tk.Tk()

# Checkbuttons
options = ["Python", "JavaScript", "Rust"]
vars_ = []
for opt in options:
    var = tk.BooleanVar()
    vars_.append(var)
    cb = tk.Checkbutton(root, text=opt, variable=var,
                        font=("Arial", 11),
                        command=lambda o=opt, v=var: print(f"{o}: {v.get()}"))
    cb.pack(anchor="w", padx=20)

# Radiobuttons
lang_var = tk.StringVar(value="Python")
for lang in ["Python", "Go", "Rust"]:
    rb = tk.Radiobutton(root, text=lang, variable=lang_var, value=lang,
                        font=("Arial", 11),
                        command=lambda: print(lang_var.get()))
    rb.pack(anchor="w", padx=20)

root.mainloop()
```

### Scale (Slider) and Spinbox

```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()

# Horizontal scale
volume = tk.IntVar(value=50)
scale = tk.Scale(root, variable=volume,
                 from_=0, to=100,
                 orient=tk.HORIZONTAL,
                 length=300,
                 tickinterval=25,
                 label="Volume",
                 command=lambda v: print(f"Volume: {v}"))
scale.pack(pady=10)

# ttk Spinbox
spin_var = tk.IntVar(value=5)
spinbox = ttk.Spinbox(root, from_=1, to=100,
                      textvariable=spin_var,
                      width=10,
                      command=lambda: print(spin_var.get()))
spinbox.pack()

# String spinbox
days = ttk.Spinbox(root, values=("Mon", "Tue", "Wed", "Thu", "Fri"),
                   width=8)
days.pack()

root.mainloop()
```

---

## 4. Advanced Widgets

### Combobox (Dropdown)

```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()

# Editable dropdown
selected = tk.StringVar()
combo = ttk.Combobox(root, textvariable=selected,
                     values=["Option A", "Option B", "Option C"],
                     state="readonly",    # Prevent manual input; remove for editable
                     width=25)
combo.set("Option A")   # Default
combo.pack(padx=20, pady=10)

def on_select(event):
    print(f"Selected: {selected.get()}")

combo.bind("<<ComboboxSelected>>", on_select)

# Dynamically update values
combo["values"] = ["New 1", "New 2", "New 3"]

root.mainloop()
```

### Listbox

```python
import tkinter as tk

root = tk.Tk()

frame = tk.Frame(root)
frame.pack(padx=10, pady=10)

listbox = tk.Listbox(frame,
                     selectmode=tk.EXTENDED,  # SINGLE, BROWSE, MULTIPLE, EXTENDED
                     font=("Arial", 11),
                     bg="#f5f5f5",
                     activestyle="dotbox",
                     height=8, width=30)
listbox.pack(side=tk.LEFT)

scroll = tk.Scrollbar(frame, orient=tk.VERTICAL, command=listbox.yview)
scroll.pack(side=tk.RIGHT, fill=tk.Y)
listbox.config(yscrollcommand=scroll.set)

items = ["Apple", "Banana", "Cherry", "Date", "Fig", "Grape"]
for item in items:
    listbox.insert(tk.END, item)

# Selection handling
def on_select(event):
    selection = listbox.curselection()
    selected = [listbox.get(i) for i in selection]
    print(f"Selected: {selected}")

listbox.bind("<<ListboxSelect>>", on_select)

# Add / remove
listbox.insert(tk.END, "Mango")
listbox.delete(0)              # Remove first item

# Styling individual items
listbox.itemconfig(1, bg="#ffe0b2", fg="#e65100")

root.mainloop()
```

### Treeview — The Data Grid

`ttk.Treeview` serves as both a tree view and a full-featured data table.

```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()
root.geometry("700x400")

# --- Setup ---
columns = ("id", "name", "age", "city")
tree = ttk.Treeview(root, columns=columns, show="headings",
                    selectmode="browse")

# Column headers
for col in columns:
    tree.heading(col, text=col.title(),
                 command=lambda c=col: sort_column(tree, c, False))

# Column widths and alignment
tree.column("id",   width=60,  anchor="center")
tree.column("name", width=200, anchor="w")
tree.column("age",  width=80,  anchor="center")
tree.column("city", width=150, anchor="w")

# Scrollbars
vsb = ttk.Scrollbar(root, orient=tk.VERTICAL, command=tree.yview)
hsb = ttk.Scrollbar(root, orient=tk.HORIZONTAL, command=tree.xview)
tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)

tree.grid(row=0, column=0, sticky="nsew")
vsb.grid(row=0, column=1, sticky="ns")
hsb.grid(row=1, column=0, sticky="ew")
root.rowconfigure(0, weight=1)
root.columnconfigure(0, weight=1)

# Insert data
data = [
    (1, "Alice Johnson",  28, "New York"),
    (2, "Bob Smith",      34, "London"),
    (3, "Carol Williams", 22, "Bangalore"),
]

for i, row in enumerate(data):
    tag = "even" if i % 2 == 0 else "odd"
    tree.insert("", tk.END, values=row, tags=(tag,))

# Alternating row colors
tree.tag_configure("even", background="#f9f9f9")
tree.tag_configure("odd",  background="#ffffff")

# --- Sorting ---
def sort_column(tv, col, reverse):
    data = [(tv.set(k, col), k) for k in tv.get_children("")]
    try:
        data.sort(key=lambda x: float(x[0]), reverse=reverse)
    except ValueError:
        data.sort(reverse=reverse)
    for i, (_, k) in enumerate(data):
        tv.move(k, "", i)
        tv.item(k, tags=("even" if i % 2 == 0 else "odd",))
    tree.heading(col, command=lambda: sort_column(tv, col, not reverse))

# --- CRUD operations ---
def get_selected():
    sel = tree.selection()
    if sel:
        return tree.item(sel[0], "values")
    return None

def delete_selected():
    sel = tree.selection()
    if sel:
        tree.delete(sel[0])

def edit_selected(new_values):
    sel = tree.selection()
    if sel:
        tree.item(sel[0], values=new_values)

# --- Hierarchical (tree mode) ---
# Use show="tree headings" and parent IDs for nested rows:
# parent_id = tree.insert("", tk.END, text="Parent", values=(...))
# tree.insert(parent_id, tk.END, text="Child", values=(...))

root.mainloop()
```

### Notebook (Tabs)

```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()

notebook = ttk.Notebook(root)
notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)

# Create tab frames
tab1 = ttk.Frame(notebook)
tab2 = ttk.Frame(notebook)
tab3 = ttk.Frame(notebook)

notebook.add(tab1, text="  General  ")
notebook.add(tab2, text="  Advanced  ")
notebook.add(tab3, text="  About  ")

# Populate tabs
ttk.Label(tab1, text="General Settings", font=("Arial", 14)).pack(pady=20)
ttk.Label(tab2, text="Advanced Options", font=("Arial", 14)).pack(pady=20)

# Listen for tab change
def on_tab_change(event):
    tab = notebook.index(notebook.select())
    print(f"Switched to tab {tab}")

notebook.bind("<<NotebookTabChanged>>", on_tab_change)

# Programmatic switch
notebook.select(1)   # Switch to tab index 1

root.mainloop()
```

### Canvas — Drawing and Custom Widgets

```python
import tkinter as tk
import math

root = tk.Tk()

canvas = tk.Canvas(root, width=500, height=400, bg="white")
canvas.pack()

# Shapes
canvas.create_rectangle(50, 50, 200, 150, fill="#3498db", outline="#2980b9", width=2)
canvas.create_oval(220, 50, 370, 150, fill="#e74c3c", outline="")
canvas.create_line(50, 200, 400, 200, fill="#2ecc71", width=3, dash=(10, 5))
canvas.create_polygon(250, 220, 200, 320, 300, 320,
                      fill="#f39c12", outline="#e67e22")
canvas.create_text(250, 360, text="Canvas Demo",
                   font=("Arial", 16, "bold"), fill="#333")

# Move / update items
rect_id = canvas.create_rectangle(10, 10, 60, 60, fill="red")
canvas.move(rect_id, 50, 50)
canvas.itemconfig(rect_id, fill="blue")
canvas.coords(rect_id, 100, 100, 160, 160)

# Image on canvas
img = tk.PhotoImage(file="icon.png")
canvas.create_image(400, 100, image=img, anchor="nw")

# Click detection
def on_canvas_click(event):
    items = canvas.find_overlapping(event.x-2, event.y-2, event.x+2, event.y+2)
    if items:
        canvas.itemconfig(items[0], fill="purple")

canvas.bind("<Button-1>", on_canvas_click)

# Animation loop
def animate():
    canvas.move(rect_id, 2, 0)
    x1, _, x2, _ = canvas.coords(rect_id)
    if x2 > 500:
        canvas.coords(rect_id, -50, 100, 10, 160)
    root.after(16, animate)   # ~60fps

animate()
root.mainloop()
```

### PanedWindow — Resizable Panes

```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()
root.geometry("700x500")

paned = ttk.PanedWindow(root, orient=tk.HORIZONTAL)
paned.pack(fill=tk.BOTH, expand=True)

left = ttk.Frame(paned, width=200, relief=tk.SUNKEN)
right = ttk.Frame(paned)

paned.add(left, weight=1)
paned.add(right, weight=3)

ttk.Label(left, text="Sidebar").pack(pady=10)
ttk.Label(right, text="Main Content").pack(pady=10)

root.mainloop()
```

### ScrolledText (Convenience Widget)

```python
from tkinter.scrolledtext import ScrolledText
import tkinter as tk

root = tk.Tk()
st = ScrolledText(root, width=60, height=20, font=("Courier", 11))
st.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)
st.insert(tk.END, "This widget has a built-in scrollbar.")
root.mainloop()
```

---

## 5. Styling with ttk and Themes

### ttk Themes

```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()
style = ttk.Style()

# List available themes
print(style.theme_names())
# ('winnative', 'clam', 'alt', 'default', 'classic', 'vista', 'xpnative')
# macOS adds: 'aqua'
# Linux: 'clam', 'alt', 'default', 'classic'

style.theme_use("clam")   # Best cross-platform base for custom styling
```

### Custom ttk Styling

```python
style = ttk.Style()
style.theme_use("clam")

# Style a Button
style.configure("Accent.TButton",
                background="#3498db",
                foreground="white",
                font=("Arial", 11, "bold"),
                padding=(12, 6),
                relief="flat",
                borderwidth=0)

style.map("Accent.TButton",
          background=[("active", "#2980b9"), ("disabled", "#bdc3c7")],
          foreground=[("disabled", "#7f8c8d")])

# Style a Frame
style.configure("Card.TFrame",
                background="white",
                relief="flat",
                borderwidth=1)

# Style Treeview
style.configure("Treeview",
                background="#ffffff",
                fieldbackground="#ffffff",
                rowheight=28,
                font=("Arial", 10))
style.configure("Treeview.Heading",
                background="#2c3e50",
                foreground="white",
                font=("Arial", 10, "bold"),
                relief="flat")
style.map("Treeview",
          background=[("selected", "#3498db")],
          foreground=[("selected", "white")])

# Usage
btn = ttk.Button(root, text="Save", style="Accent.TButton")
btn.pack()
```

### Third-Party Themes: ttkthemes and ttkbootstrap

```bash
pip install ttkthemes ttkbootstrap
```

```python
# ttkthemes
from ttkthemes import ThemedTk
root = ThemedTk(theme="arc")   # "arc", "breeze", "equilux" (dark), "yaru"

# ttkbootstrap — most feature-rich
import ttkbootstrap as ttk
from ttkbootstrap.constants import *

root = ttk.Window(themename="darkly")   # "flatly", "litera", "cosmo", "darkly", "superhero"
ttk.Button(root, text="Primary", bootstyle=PRIMARY).pack(pady=5)
ttk.Button(root, text="Danger", bootstyle=DANGER).pack(pady=5)
ttk.Button(root, text="Outline", bootstyle=(SUCCESS, OUTLINE)).pack(pady=5)
root.mainloop()
```

---

## 6. Event Handling & Bindings

### Event Binding

```python
import tkinter as tk

root = tk.Tk()

# Keyboard events
root.bind("<Return>", lambda e: print("Enter pressed"))
root.bind("<Escape>", lambda e: root.destroy())
root.bind("<Control-s>", lambda e: save())
root.bind("<Control-z>", lambda e: undo())
root.bind("<F5>", lambda e: refresh())

# Key press anywhere in app (bind_all)
root.bind_all("<Control-q>", lambda e: root.quit())

# Mouse events
canvas = tk.Canvas(root, width=400, height=300, bg="white")
canvas.pack()
canvas.bind("<Button-1>", lambda e: print(f"Left click at {e.x},{e.y}"))
canvas.bind("<Button-3>", lambda e: print("Right click"))
canvas.bind("<Double-Button-1>", lambda e: print("Double click"))
canvas.bind("<B1-Motion>", lambda e: print(f"Dragging to {e.x},{e.y}"))
canvas.bind("<MouseWheel>", lambda e: print(f"Scroll delta: {e.delta}"))

# Focus events
entry = tk.Entry(root)
entry.pack()
entry.bind("<FocusIn>", lambda e: entry.config(bg="#fffde7"))
entry.bind("<FocusOut>", lambda e: entry.config(bg="white"))

# Widget-level vs window-level
# widget.bind() — only that widget
# root.bind() — root window only
# root.bind_all() — entire application

root.mainloop()
```

### StringVar, IntVar, BooleanVar, DoubleVar

```python
import tkinter as tk

root = tk.Tk()

# Variables auto-update linked widgets
name = tk.StringVar(value="")
count = tk.IntVar(value=0)
enabled = tk.BooleanVar(value=True)

entry = tk.Entry(root, textvariable=name)
entry.pack()

label = tk.Label(root, textvariable=name)  # Mirror of entry
label.pack()

# Trace: run callback on change
def on_name_change(*args):
    print(f"Name is now: {name.get()}")

trace_id = name.trace_add("write", on_name_change)  # "write", "read", "unset"
name.trace_remove("write", trace_id)  # Remove trace

# Programmatic set
name.set("John Doe")
print(name.get())

root.mainloop()
```

### after() — The Event Loop Timer

Never use `time.sleep()` in a tkinter app — it freezes the GUI. Use `after()` instead.

```python
import tkinter as tk
import datetime

root = tk.Tk()
time_label = tk.Label(root, font=("Arial", 24))
time_label.pack(pady=20)

def update_clock():
    now = datetime.datetime.now().strftime("%H:%M:%S")
    time_label.config(text=now)
    root.after(1000, update_clock)   # Schedule next call in 1000ms

update_clock()
root.mainloop()
```

---

## 7. Dialogs, Menus, and System Tray

### Built-in Dialogs

```python
from tkinter import messagebox, filedialog, simpledialog, colorchooser
import tkinter as tk

root = tk.Tk()

# Message boxes
messagebox.showinfo("Title", "Info message")
messagebox.showwarning("Title", "Warning message")
messagebox.showerror("Title", "Error message")
result = messagebox.askyesno("Confirm", "Are you sure?")  # Returns bool
result = messagebox.askokcancel("Confirm", "Proceed?")

# Simple input
name = simpledialog.askstring("Input", "What is your name?", parent=root)
age  = simpledialog.askinteger("Input", "Your age:", minvalue=1, maxvalue=120)

# File dialogs
path = filedialog.askopenfilename(
    title="Open File",
    initialdir="/home",
    filetypes=[("Text files", "*.txt"), ("Python files", "*.py"), ("All files", "*.*")]
)
paths = filedialog.askopenfilenames(...)  # Multiple files
save_path = filedialog.asksaveasfilename(defaultextension=".txt")
folder = filedialog.askdirectory(title="Select Folder")

# Color chooser
color = colorchooser.askcolor(title="Pick a color", initialcolor="#3498db")
# Returns: ((r, g, b), "#rrggbb") or (None, None) if cancelled
if color[1]:
    print(f"Hex: {color[1]}")
```

### Menu Bar

```python
import tkinter as tk

root = tk.Tk()

menubar = tk.Menu(root)
root.config(menu=menubar)

# File menu
file_menu = tk.Menu(menubar, tearoff=0)
menubar.add_cascade(label="File", menu=file_menu)
file_menu.add_command(label="New",       command=lambda: print("New"), accelerator="Ctrl+N")
file_menu.add_command(label="Open...",   command=lambda: print("Open"), accelerator="Ctrl+O")
file_menu.add_separator()
file_menu.add_command(label="Exit",      command=root.quit)

# Edit menu
edit_menu = tk.Menu(menubar, tearoff=0)
menubar.add_cascade(label="Edit", menu=edit_menu)
edit_menu.add_command(label="Undo", command=lambda: print("Undo"), accelerator="Ctrl+Z")
edit_menu.add_command(label="Redo", command=lambda: print("Redo"), accelerator="Ctrl+Y")

# View menu with checkbuttons
view_menu = tk.Menu(menubar, tearoff=0)
menubar.add_cascade(label="View", menu=view_menu)
show_toolbar = tk.BooleanVar(value=True)
view_menu.add_checkbutton(label="Toolbar", variable=show_toolbar)

# Submenu
theme_menu = tk.Menu(view_menu, tearoff=0)
view_menu.add_cascade(label="Theme", menu=theme_menu)
for t in ["Light", "Dark", "System"]:
    theme_menu.add_command(label=t, command=lambda x=t: print(f"Theme: {x}"))

root.mainloop()
```

### Context Menu (Right-click)

```python
import tkinter as tk

root = tk.Tk()
text = tk.Text(root, width=40, height=10)
text.pack()

context_menu = tk.Menu(root, tearoff=0)
context_menu.add_command(label="Cut",   command=lambda: text.event_generate("<<Cut>>"))
context_menu.add_command(label="Copy",  command=lambda: text.event_generate("<<Copy>>"))
context_menu.add_command(label="Paste", command=lambda: text.event_generate("<<Paste>>"))
context_menu.add_separator()
context_menu.add_command(label="Select All",
                          command=lambda: text.tag_add("sel", "1.0", "end"))

def show_context(event):
    context_menu.tk_popup(event.x_root, event.y_root)

text.bind("<Button-3>", show_context)
root.mainloop()
```

### System Tray with pystray

```bash
pip install pystray Pillow
```

```python
import tkinter as tk
import threading
from PIL import Image, ImageDraw
import pystray

class TrayApp:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Tray App")
        self.root.protocol("WM_DELETE_WINDOW", self.hide_window)

        tk.Label(self.root, text="App is running. Close hides to tray.").pack(pady=20)
        tk.Button(self.root, text="Quit", command=self.quit_app).pack()

        self.tray_icon = self._create_tray_icon()
        tray_thread = threading.Thread(target=self.tray_icon.run, daemon=True)
        tray_thread.start()

    def _create_icon_image(self):
        img = Image.new("RGB", (64, 64), "#3498db")
        d = ImageDraw.Draw(img)
        d.ellipse([16, 16, 48, 48], fill="white")
        return img

    def _create_tray_icon(self):
        menu = pystray.Menu(
            pystray.MenuItem("Show", self.show_window, default=True),
            pystray.MenuItem("Quit", self.quit_app)
        )
        return pystray.Icon("myapp", self._create_icon_image(), "My App", menu)

    def hide_window(self):
        self.root.withdraw()

    def show_window(self):
        self.root.after(0, self.root.deiconify)

    def quit_app(self):
        self.tray_icon.stop()
        self.root.after(0, self.root.destroy)

    def run(self):
        self.root.mainloop()

TrayApp().run()
```

---

## 8. Multi-threading & Responsiveness

### The Problem

Tkinter's event loop is single-threaded. Running a long task on the main thread freezes the UI completely. **Never do I/O, sleep, or heavy computation directly in a callback.**

### Pattern 1: threading + queue (recommended)

```python
import tkinter as tk
from tkinter import ttk
import threading
import queue
import time

class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Threading Demo")
        self.geometry("400x200")
        self.queue = queue.Queue()

        self.label = ttk.Label(self, text="Press Start", font=("Arial", 12))
        self.label.pack(pady=20)

        self.progress = ttk.Progressbar(self, mode="determinate", length=300)
        self.progress.pack()

        self.btn = ttk.Button(self, text="Start Task", command=self.start_task)
        self.btn.pack(pady=10)

        self.after(100, self.poll_queue)

    def start_task(self):
        self.btn.config(state=tk.DISABLED)
        thread = threading.Thread(target=self.background_task, daemon=True)
        thread.start()

    def background_task(self):
        """Runs in background thread — never touch widgets here."""
        for i in range(1, 11):
            time.sleep(0.5)                              # Simulate work
            self.queue.put(("progress", i * 10, f"Processing step {i}/10"))
        self.queue.put(("done", 100, "Task complete!"))

    def poll_queue(self):
        """Drains queue on main thread — safe to update widgets here."""
        try:
            while True:
                msg_type, value, text = self.queue.get_nowait()
                self.progress["value"] = value
                self.label.config(text=text)
                if msg_type == "done":
                    self.btn.config(state=tk.NORMAL)
        except queue.Empty:
            pass
        self.after(100, self.poll_queue)

App().mainloop()
```

### Pattern 2: concurrent.futures + after()

```python
import tkinter as tk
from tkinter import ttk
from concurrent.futures import ThreadPoolExecutor
import requests   # pip install requests

executor = ThreadPoolExecutor(max_workers=4)

class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.result_var = tk.StringVar(value="...")
        ttk.Label(self, textvariable=self.result_var).pack(pady=20)
        ttk.Button(self, text="Fetch Data", command=self.fetch).pack()

    def fetch(self):
        self.result_var.set("Loading...")
        future = executor.submit(self._do_request)
        self.after(100, lambda: self._check_future(future))

    def _do_request(self):
        r = requests.get("https://api.github.com")
        return r.json().get("current_user_url", "N/A")

    def _check_future(self, future):
        if future.done():
            try:
                result = future.result()
                self.result_var.set(f"Result: {result}")
            except Exception as e:
                self.result_var.set(f"Error: {e}")
        else:
            self.after(100, lambda: self._check_future(future))

App().mainloop()
```

### Pattern 3: asyncio + tkinter

```python
import tkinter as tk
from tkinter import ttk
import asyncio
import threading

class AsyncApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.loop = asyncio.new_event_loop()
        self._start_async_loop()

        self.label = ttk.Label(self, text="Ready", font=("Arial", 12))
        self.label.pack(pady=20)
        ttk.Button(self, text="Run Async", command=self.run_async_task).pack()

    def _start_async_loop(self):
        def run():
            asyncio.set_event_loop(self.loop)
            self.loop.run_forever()
        threading.Thread(target=run, daemon=True).start()

    def run_async_task(self):
        asyncio.run_coroutine_threadsafe(self._async_work(), self.loop)

    async def _async_work(self):
        self.after(0, lambda: self.label.config(text="Working..."))
        await asyncio.sleep(2)   # Async I/O here (aiohttp, etc.)
        self.after(0, lambda: self.label.config(text="Done!"))

AsyncApp().mainloop()
```

### Thread Safety Rules

- **Never call widget methods from a background thread.** Only the main thread can safely call `.config()`, `.insert()`, `.delete()`, etc.
- Use `root.after(0, callback)` to schedule UI updates from any thread.
- Use `queue.Queue` to pass data from background threads to the main thread.
- Use `threading.Event` to signal cancellation to background threads.

---

## 9. Data Persistence: SQLite, JSON, Config Files

### SQLite with tkinter

```python
import sqlite3
import tkinter as tk
from tkinter import ttk

DB_PATH = "tasks.db"

def init_db():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("""
        CREATE TABLE IF NOT EXISTS tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            done INTEGER DEFAULT 0
        )
    """)
    conn.commit()
    conn.close()

def get_tasks():
    conn = sqlite3.connect(DB_PATH)
    rows = conn.execute("SELECT id, title, done FROM tasks").fetchall()
    conn.close()
    return rows

def add_task(title: str):
    conn = sqlite3.connect(DB_PATH)
    conn.execute("INSERT INTO tasks (title) VALUES (?)", (title,))
    conn.commit()
    conn.close()

def delete_task(task_id: int):
    conn = sqlite3.connect(DB_PATH)
    conn.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
    conn.commit()
    conn.close()

init_db()

# Wire into a UI
root = tk.Tk()
tree = ttk.Treeview(root, columns=("id", "title", "done"), show="headings")
for c in ("id", "title", "done"):
    tree.heading(c, text=c.title())
tree.pack(fill=tk.BOTH, expand=True)

def refresh():
    tree.delete(*tree.get_children())
    for row in get_tasks():
        tree.insert("", tk.END, values=row)

refresh()
root.mainloop()
```

### Config with configparser

```python
import configparser
import os

CONFIG_PATH = "config.ini"

def load_config():
    cfg = configparser.ConfigParser()
    if os.path.exists(CONFIG_PATH):
        cfg.read(CONFIG_PATH)
    else:
        cfg["appearance"] = {"theme": "light", "font_size": "12"}
        cfg["window"] = {"width": "800", "height": "600"}
        save_config(cfg)
    return cfg

def save_config(cfg):
    with open(CONFIG_PATH, "w") as f:
        cfg.write(f)

config = load_config()
theme = config.get("appearance", "theme", fallback="light")
config.set("appearance", "theme", "dark")
save_config(config)
```

---

## 10. Modern HTML Apps with Web Wrappers

### Option 1: tkinterweb — Render HTML/CSS Natively

```bash
pip install tkinterweb
```

```python
import tkinter as tk
from tkinterweb import HtmlFrame

root = tk.Tk()
root.title("HTML App")
root.geometry("900x700")

frame = HtmlFrame(root, horizontal_scrollbar="auto")
frame.pack(fill=tk.BOTH, expand=True)

# Load from URL
frame.load_url("https://example.com")

# Load from HTML string
html = """
<!DOCTYPE html>
<html>
<head>
<style>
  body { font-family: Arial; background: #1e1e1e; color: #d4d4d4; padding: 20px; }
  h1 { color: #569cd6; }
  .card { background: #252526; border-radius: 8px; padding: 16px; margin: 10px 0; }
  button { background: #0e639c; color: white; border: none; padding: 8px 16px;
           border-radius: 4px; cursor: pointer; }
  button:hover { background: #1177bb; }
</style>
</head>
<body>
  <h1>Hello from HTML</h1>
  <div class="card">
    <p>This is rendered natively inside tkinter.</p>
    <button onclick="window.pycommand('btn_clicked')">Click Me</button>
  </div>
</body>
</html>
"""
frame.load_html(html)

# Handle clicks from HTML → Python
def on_link_click(url):
    if url.startswith("pycommand://"):
        command = url[len("pycommand://"):]
        print(f"Python received: {command}")

frame.on_link_click = on_link_click

root.mainloop()
```

### Option 2: pywebview — Full WebKit/Chromium Bridge

```bash
pip install pywebview
```

```python
import webview
import threading
import json

class API:
    """Python methods callable from JavaScript via window.pywebview.api"""

    def get_data(self):
        return {"message": "Hello from Python!", "version": "1.0"}

    def save_file(self, content):
        with open("output.txt", "w") as f:
            f.write(content)
        return {"success": True}

    def show_dialog(self):
        # Runs on separate thread — post to main thread if needed
        result = webview.windows[0].create_file_dialog(webview.OPEN_DIALOG)
        return result[0] if result else None

api = API()

html = """
<!DOCTYPE html>
<html>
<head>
  <title>pywebview App</title>
  <style>
    body { font-family: 'Segoe UI', sans-serif; padding: 30px; background: #f5f5f5; }
    button { padding: 10px 20px; background: #2196f3; color: white;
             border: none; border-radius: 5px; cursor: pointer; margin: 5px; }
    #output { background: white; padding: 16px; border-radius: 8px;
              margin-top: 20px; min-height: 60px; }
  </style>
</head>
<body>
  <h1>pywebview Demo</h1>
  <button onclick="getData()">Get Data from Python</button>
  <button onclick="openFile()">Open File</button>
  <div id="output">Output appears here...</div>

  <script>
    async function getData() {
      const result = await pywebview.api.get_data();
      document.getElementById('output').textContent = JSON.stringify(result, null, 2);
    }

    async function openFile() {
      const path = await pywebview.api.show_dialog();
      if (path) {
        document.getElementById('output').textContent = 'Selected: ' + path;
      }
    }

    // Send message to Python
    function sendToPython(data) {
      pywebview.api.save_file(data);
    }
  </script>
</body>
</html>
"""

# Create window
window = webview.create_window(
    title="My App",
    html=html,
    js_api=api,
    width=900,
    height=700,
    resizable=True,
    frameless=False,
    on_top=False
)

webview.start(debug=False)
```

### Option 3: Embedding a React/HTML App via CEF

For full Chromium embedding in a tkinter shell:

```bash
pip install cefpython3
```

```python
from cefpython3 import cefpython as cef
import tkinter as tk
import sys, os

def main():
    sys.excepthook = cef.ExceptHook
    settings = {"windowless_rendering_enabled": False}
    cef.Initialize(settings)

    root = tk.Tk()
    root.title("CEF Browser")
    root.geometry("1000x700")

    # Embed browser
    browser_frame = tk.Frame(root)
    browser_frame.pack(fill=tk.BOTH, expand=True)
    root.update()

    window_info = cef.WindowInfo()
    rect = [0, 0, browser_frame.winfo_width(), browser_frame.winfo_height()]
    window_info.SetAsChild(browser_frame.winfo_id(), rect)

    browser = cef.CreateBrowserSync(window_info, url="http://localhost:3000")

    root.mainloop()
    cef.Shutdown()

if __name__ == "__main__":
    main()
```

### Hybrid Pattern: tkinter Shell + Embedded Browser

For maximum capability, run a local server serving your React/Vue app:

```python
import tkinter as tk
from tkinter import ttk
import webview
import threading
from http.server import SimpleHTTPRequestHandler, HTTPServer
import os

PORT = 5173   # Or wherever your Vite/React dev/dist server runs

class LocalServer(threading.Thread):
    def __init__(self, directory):
        super().__init__(daemon=True)
        self.directory = directory

    def run(self):
        os.chdir(self.directory)
        server = HTTPServer(("localhost", PORT), SimpleHTTPRequestHandler)
        server.serve_forever()

# Start local server serving ./dist/
LocalServer("./dist").start()

# Open webview pointing at it
window = webview.create_window("React App", f"http://localhost:{PORT}", width=1200, height=800)
webview.start()
```

---

## 11. Packaging & Distribution

### Method 1: pip / PyPI (Library or Installable App)

Best for distributing Python packages or CLI+GUI tools to Python users.

**pyproject.toml:**
```toml
[build-system]
requires = ["setuptools>=68", "wheel"]
build-backend = "setuptools.backends.legacy:build"

[project]
name = "my-gui-app"
version = "1.0.0"
description = "A tkinter GUI application"
requires-python = ">=3.10"
dependencies = [
    "ttkbootstrap>=1.10",
    "requests>=2.31",
    "Pillow>=10.0"
]

[project.scripts]
my-app = "my_app.main:main"   # Installs a CLI entry point
```

```bash
pip install build twine
python -m build          # Creates dist/*.whl and dist/*.tar.gz
twine upload dist/*      # Upload to PyPI
```

Install with: `pip install my-gui-app && my-app`

### Method 2: PyInstaller (Single Executable)

Most popular. Bundles Python + app into a standalone binary.

```bash
pip install pyinstaller
```

**Basic usage:**
```bash
# One-folder bundle
pyinstaller main.py --name "MyApp" --icon assets/icon.ico

# One-file executable (slower startup, good for distribution)
pyinstaller main.py --name "MyApp" --onefile --icon assets/icon.ico

# No terminal window (Windows)
pyinstaller main.py --onefile --windowed --icon assets/icon.ico
```

**Custom .spec file (recommended for complex apps):**

```python
# MyApp.spec
from PyInstaller.utils.hooks import collect_data_files, collect_submodules

a = Analysis(
    ["main.py"],
    pathex=["."],
    binaries=[],
    datas=[
        ("assets/", "assets/"),          # Include assets folder
        ("config.ini", "."),             # Include config file
    ],
    hiddenimports=[
        "tkinter",
        "ttkbootstrap",
        "PIL._tkinter_finder",
    ],
    hookspath=[],
    runtime_hooks=[],
    excludes=["pytest", "unittest"],
    noarchive=False,
)

pyz = PYZ(a.pure)
exe = EXE(
    pyz, a.scripts, a.binaries, a.zipfiles, a.datas,
    name="MyApp",
    debug=False,
    console=False,     # False = no terminal window
    icon="assets/icon.ico",
    upx=True,          # Compress (requires UPX installed)
)
```

```bash
pyinstaller MyApp.spec
```

**Common PyInstaller gotchas:**
- Hidden imports for dynamic `importlib` usage — add to `hiddenimports`
- Data files (images, CSS, templates) need to be listed in `datas`
- Use `sys._MEIPASS` to get the bundle path at runtime:

```python
import sys, os

def resource_path(relative):
    """Get absolute path to resource — works for dev and PyInstaller."""
    base = getattr(sys, "_MEIPASS", os.path.abspath("."))
    return os.path.join(base, relative)

icon_path = resource_path("assets/icon.ico")
```

### Method 3: cx_Freeze

Good alternative to PyInstaller, especially on Linux.

```bash
pip install cx_Freeze
```

**setup.py:**
```python
from cx_Freeze import setup, Executable
import sys

base = "Win32GUI" if sys.platform == "win32" else None

build_exe_options = {
    "packages": ["tkinter", "ttkbootstrap"],
    "include_files": [("assets/", "assets/")],
    "excludes": ["unittest", "pytest"],
}

setup(
    name="MyApp",
    version="1.0",
    description="My tkinter App",
    options={"build_exe": build_exe_options},
    executables=[
        Executable(
            "main.py",
            base=base,
            target_name="MyApp",
            icon="assets/icon.ico",
        )
    ]
)
```

```bash
python setup.py build    # Outputs to build/exe.*
python setup.py bdist_msi  # Creates Windows installer
```

### Method 4: Nuitka (Compiled Binary)

Nuitka compiles Python to C, then to a native binary. Slower build, faster startup, harder to reverse-engineer.

```bash
pip install nuitka
# Windows: also needs VS Build Tools
# Linux: needs gcc
```

```bash
# Standalone build (no Python required on target)
python -m nuitka \
  --standalone \
  --onefile \
  --windows-disable-console \
  --windows-icon-from-ico=assets/icon.ico \
  --include-data-dir=assets=assets \
  --enable-plugin=tk-inter \
  --output-dir=dist \
  main.py
```

**Key Nuitka flags:**

| Flag | Purpose |
|------|---------|
| `--standalone` | Bundle all dependencies |
| `--onefile` | Single executable |
| `--enable-plugin=tk-inter` | Properly bundle tkinter |
| `--enable-plugin=numpy` | Add if using numpy |
| `--include-data-dir=src=dst` | Include data directories |
| `--windows-disable-console` | No terminal window |
| `--lto=yes` | Link-time optimization (smaller binary) |

### Method 5: briefcase (cross-platform, app store ready)

```bash
pip install briefcase
briefcase new          # Interactive project setup
briefcase dev          # Run in dev mode
briefcase build        # Build for current platform
briefcase package      # Create installer/dmg/deb
briefcase run          # Run the built app
```

### Comparison Table

| Method | Platforms | Output | Startup | Skill Level | Best For |
|--------|-----------|--------|---------|-------------|----------|
| pip/PyPI | All | Package | n/a | Low | Dev tools, libraries |
| PyInstaller | Win/Mac/Linux | Folder or .exe | Medium | Low | Most apps |
| cx_Freeze | Win/Mac/Linux | Folder | Medium | Medium | Windows installers |
| Nuitka | Win/Mac/Linux | Native binary | Fast | Medium-High | Performance, obfuscation |
| briefcase | Win/Mac/Linux/iOS/Android | Native app | Medium | Medium | App store distribution |

---

## 12. Real-World Project: A Full Task Manager App

This brings together everything: grid layout, treeview, dialogs, threading, SQLite, and ttk styling.

```python
# task_manager.py — Complete working example
import tkinter as tk
from tkinter import ttk, messagebox, simpledialog
import sqlite3
import threading
import queue
import time
import os

DB_PATH = "tasks.db"

# ─────────────────────────── Database Layer ───────────────────────────

def init_db():
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS tasks (
                id    INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                prio  TEXT DEFAULT 'Medium',
                done  INTEGER DEFAULT 0,
                ts    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

def db_get_all():
    with sqlite3.connect(DB_PATH) as conn:
        return conn.execute(
            "SELECT id, title, prio, done FROM tasks ORDER BY ts DESC"
        ).fetchall()

def db_add(title, prio):
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("INSERT INTO tasks (title, prio) VALUES (?, ?)", (title, prio))

def db_delete(task_id):
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("DELETE FROM tasks WHERE id = ?", (task_id,))

def db_toggle(task_id):
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("UPDATE tasks SET done = 1 - done WHERE id = ?", (task_id,))

# ─────────────────────────── Main App ───────────────────────────

class TaskManagerApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Task Manager")
        self.geometry("750x520")
        self.minsize(500, 350)

        self._setup_style()
        self._build_ui()
        self._queue = queue.Queue()

        init_db()
        self.refresh_list()
        self.after(200, self._poll_queue)

    def _setup_style(self):
        style = ttk.Style(self)
        style.theme_use("clam")

        BG = "#f0f2f5"
        ACCENT = "#4f46e5"
        self.configure(bg=BG)

        style.configure("TFrame", background=BG)
        style.configure("TLabel", background=BG, font=("Segoe UI", 10))
        style.configure("Title.TLabel", font=("Segoe UI", 18, "bold"),
                        foreground=ACCENT, background=BG)
        style.configure("Accent.TButton",
                        background=ACCENT, foreground="white",
                        font=("Segoe UI", 10, "bold"),
                        padding=(10, 6), relief="flat", borderwidth=0)
        style.map("Accent.TButton",
                  background=[("active", "#4338ca"), ("disabled", "#a5b4fc")])
        style.configure("Danger.TButton",
                        background="#ef4444", foreground="white",
                        font=("Segoe UI", 10), padding=(10, 6), relief="flat")
        style.map("Danger.TButton", background=[("active", "#dc2626")])
        style.configure("Treeview", rowheight=32, font=("Segoe UI", 10),
                        background="white", fieldbackground="white")
        style.configure("Treeview.Heading", font=("Segoe UI", 10, "bold"),
                        background="#e0e7ff", foreground="#312e81")
        style.map("Treeview", background=[("selected", ACCENT)],
                  foreground=[("selected", "white")])

    def _build_ui(self):
        # ── Header
        header = ttk.Frame(self, padding=(20, 15, 20, 10))
        header.pack(fill=tk.X)
        ttk.Label(header, text="Task Manager", style="Title.TLabel").pack(side=tk.LEFT)
        self.count_label = ttk.Label(header, text="", font=("Segoe UI", 9),
                                     foreground="#6b7280")
        self.count_label.pack(side=tk.LEFT, padx=12)

        # ── Add Task Bar
        add_bar = ttk.Frame(self, padding=(20, 0, 20, 10))
        add_bar.pack(fill=tk.X)
        add_bar.columnconfigure(0, weight=1)

        self.task_var = tk.StringVar()
        entry = ttk.Entry(add_bar, textvariable=self.task_var,
                          font=("Segoe UI", 11))
        entry.grid(row=0, column=0, sticky="ew", ipady=5, padx=(0, 8))
        entry.bind("<Return>", lambda e: self.add_task())

        self.prio_var = tk.StringVar(value="Medium")
        prio_combo = ttk.Combobox(add_bar, textvariable=self.prio_var,
                                  values=["High", "Medium", "Low"],
                                  state="readonly", width=9)
        prio_combo.grid(row=0, column=1, padx=(0, 8))

        ttk.Button(add_bar, text="＋ Add", style="Accent.TButton",
                   command=self.add_task).grid(row=0, column=2)

        # ── Treeview
        tree_frame = ttk.Frame(self, padding=(20, 0, 20, 10))
        tree_frame.pack(fill=tk.BOTH, expand=True)
        tree_frame.columnconfigure(0, weight=1)
        tree_frame.rowconfigure(0, weight=1)

        cols = ("id", "title", "priority", "status")
        self.tree = ttk.Treeview(tree_frame, columns=cols, show="headings",
                                 selectmode="browse")
        self.tree.heading("id",       text="#",        anchor="center")
        self.tree.heading("title",    text="Task")
        self.tree.heading("priority", text="Priority",  anchor="center")
        self.tree.heading("status",   text="Status",    anchor="center")
        self.tree.column("id",       width=45,  anchor="center")
        self.tree.column("title",    width=350)
        self.tree.column("priority", width=90,  anchor="center")
        self.tree.column("status",   width=90,  anchor="center")

        vsb = ttk.Scrollbar(tree_frame, orient=tk.VERTICAL, command=self.tree.yview)
        self.tree.configure(yscrollcommand=vsb.set)
        self.tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")

        self.tree.tag_configure("done",   foreground="#9ca3af")
        self.tree.tag_configure("high",   foreground="#dc2626")
        self.tree.tag_configure("medium", foreground="#d97706")
        self.tree.tag_configure("low",    foreground="#16a34a")
        self.tree.bind("<Double-1>", lambda e: self.toggle_task())

        # ── Action Buttons
        btn_bar = ttk.Frame(self, padding=(20, 0, 20, 15))
        btn_bar.pack(fill=tk.X)
        ttk.Button(btn_bar, text="✓ Toggle Done",
                   style="Accent.TButton", command=self.toggle_task).pack(side=tk.LEFT)
        ttk.Button(btn_bar, text="✕ Delete",
                   style="Danger.TButton", command=self.delete_task).pack(side=tk.LEFT, padx=8)
        ttk.Button(btn_bar, text="⟳ Refresh",
                   command=self.refresh_list).pack(side=tk.RIGHT)

        # ── Status Bar
        self.status_var = tk.StringVar(value="Ready")
        status_bar = ttk.Label(self, textvariable=self.status_var,
                               relief=tk.SUNKEN, anchor="w",
                               font=("Segoe UI", 9), foreground="#6b7280")
        status_bar.pack(fill=tk.X, side=tk.BOTTOM)

    def refresh_list(self):
        """Load tasks from DB in background thread."""
        self.status_var.set("Loading...")
        threading.Thread(target=self._load_tasks, daemon=True).start()

    def _load_tasks(self):
        rows = db_get_all()
        self._queue.put(("refresh", rows))

    def _render_tasks(self, rows):
        self.tree.delete(*self.tree.get_children())
        for row in rows:
            task_id, title, prio, done = row
            status = "✓ Done" if done else "Pending"
            tags = []
            if done:
                tags.append("done")
            else:
                tags.append(prio.lower())
            self.tree.insert("", tk.END, iid=str(task_id),
                             values=(task_id, title, prio, status),
                             tags=tuple(tags))
        total = len(rows)
        done = sum(1 for r in rows if r[3])
        self.count_label.config(text=f"({done}/{total} done)")
        self.status_var.set(f"Loaded {total} tasks")

    def add_task(self):
        title = self.task_var.get().strip()
        if not title:
            messagebox.showwarning("Input Error", "Please enter a task title.")
            return
        prio = self.prio_var.get()
        self.task_var.set("")
        threading.Thread(target=self._add_task_bg, args=(title, prio), daemon=True).start()

    def _add_task_bg(self, title, prio):
        db_add(title, prio)
        rows = db_get_all()
        self._queue.put(("refresh", rows))
        self._queue.put(("status", f'Added task: "{title}"'))

    def toggle_task(self):
        sel = self.tree.selection()
        if not sel:
            return
        task_id = int(sel[0])
        threading.Thread(target=self._toggle_bg, args=(task_id,), daemon=True).start()

    def _toggle_bg(self, task_id):
        db_toggle(task_id)
        rows = db_get_all()
        self._queue.put(("refresh", rows))

    def delete_task(self):
        sel = self.tree.selection()
        if not sel:
            return
        task_id = int(sel[0])
        title = self.tree.item(sel[0], "values")[1]
        if messagebox.askyesno("Confirm", f'Delete task "{title}"?'):
            threading.Thread(target=self._delete_bg, args=(task_id,), daemon=True).start()

    def _delete_bg(self, task_id):
        db_delete(task_id)
        rows = db_get_all()
        self._queue.put(("refresh", rows))
        self._queue.put(("status", "Task deleted"))

    def _poll_queue(self):
        try:
            while True:
                msg = self._queue.get_nowait()
                if msg[0] == "refresh":
                    self._render_tasks(msg[1])
                elif msg[0] == "status":
                    self.status_var.set(msg[1])
        except queue.Empty:
            pass
        self.after(100, self._poll_queue)

if __name__ == "__main__":
    app = TaskManagerApp()
    app.mainloop()
```

---

## Quick Reference Cheat Sheet

```
┌──────────────────────────────────────────────────────────┐
│  GEOMETRY MANAGERS                                        │
│  pack()  — stack vertically/horizontally, simple layouts  │
│  grid()  — table layout, use for forms & complex UIs      │
│  place() — absolute, avoid unless you know the size       │
│                                                           │
│  LAYOUT TIPS                                              │
│  columnconfigure(n, weight=1) → column expands            │
│  rowconfigure(n, weight=1)    → row expands               │
│  sticky="nsew"                → fill cell                 │
│  pack_propagate(False)        → fix frame size            │
│                                                           │
│  THREAD SAFETY                                            │
│  ✓ root.after(0, lambda: widget.config(...))              │
│  ✓ queue.Queue to pass data to main thread                │
│  ✗ Never call widget methods from background threads      │
│                                                           │
│  PACKAGING QUICK PICK                                     │
│  Quick dist to Python users  → pip / PyPI                 │
│  Windows/Mac/Linux .exe      → PyInstaller --onefile      │
│  Compiled native binary      → Nuitka                     │
│  Windows installer           → cx_Freeze bdist_msi        │
│  App store ready             → briefcase                  │
└──────────────────────────────────────────────────────────┘
```
