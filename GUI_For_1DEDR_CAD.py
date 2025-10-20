import tkinter as tk
from tkinter import messagebox, filedialog
import subprocess
import os

# --------------------------------------
# Tooltip Helper Class
# --------------------------------------
class CreateToolTip(object):
    """Create a tooltip for a given widget"""
    def __init__(self, widget, text='widget info'):
        self.widget = widget
        self.text = text
        self.tipwindow = None
        self.id = None
        self.x = self.y = 0
        widget.bind("<Enter>", self.enter)
        widget.bind("<Leave>", self.leave)

    def enter(self, event=None):
        self.schedule()

    def leave(self, event=None):
        self.unschedule()
        self.hidetip()

    def schedule(self):
        self.unschedule()
        self.id = self.widget.after(500, self.showtip)  # delay before showing tooltip

    def unschedule(self):
        id_ = self.id
        self.id = None
        if id_:
            self.widget.after_cancel(id_)

    def showtip(self, event=None):
        if self.tipwindow or not self.text:
            return
        x, y, cx, cy = self.widget.bbox("insert")
        x = x + self.widget.winfo_rootx() + 25
        y = y + cy + self.widget.winfo_rooty() + 25
        self.tipwindow = tw = tk.Toplevel(self.widget)
        tw.wm_overrideredirect(True)  # remove border
        tw.wm_geometry(f"+{x}+{y}")
        label = tk.Label(tw, text=self.text, justify='left',
                         background="#ffffe0", relief='solid', borderwidth=1,
                         font=("tahoma", "8", "normal"))
        label.pack(ipadx=1)

    def hidetip(self):
        tw = self.tipwindow
        self.tipwindow = None
        if tw:
            tw.destroy()

# --------------------------------------
# Tooltips for InputFile.txt
# --------------------------------------
file1_tooltips = {
    "EXECUTABLE_PATH":"Location where the executable and shell script is stored",
    "OUTPUTFILE_LOCATION": "Directory to save the input files and simulation results.",
    "Temperature": "Device temperature in [K].",
    "eQUANTUM_CORRECTION": "Enable electron quantum correction (0 or 1).",
    "hQUANTUM_CORRECTION": "Enable hole quantum correction (0 or 1).",
    "NO_OF_VALLEYS": "Number of valleys (Nv).",
    "NO_EIGEN_PER_VALLEY": "Number of eigenvalues per valley. (Ne)",
    "MESH_SPATIAL_DISTANCE_m": "Distance between two successive mesh points. [m]",
    "NO_OF_DOMAINS": "Domain specifications: number of domains followed by dimensions.",
    "DAMPING": "Damping factor for Poisson solver.",
    "POISSON_TOL": "Tolerance for Poisson solver.",
    "MAX_ITERATIONS": "Maximum iterations for solver.",
    "SYMMETRIC_DOUBLE_GATE": "YES/NO for symmetric double gate.",
    "GATE_BIAS": "Gate bias voltages (V).",
    "BACK_GATE_BIAS": "Back gate bias voltages (V).",
    "WORKFUNCTION_DIFF": "Work function difference (V).",
    "MATLAB_RUNTIME": "Location of MATLAB Runtime Installation"
}

# --------------------------------------
# Tooltips for File2
# --------------------------------------
file2_tooltips = {
    "Material_filename": "Filename must be Mat_<i>.txt. where i is the domain index",
    "material_type": "Material type (either oxide, silicon).",
    "effective_mass": "Electron effective mass along in the confinement direction. [m0]",
    "meDOS": "Electron density of states effective mass [m0].",
    "Conduction band Non-parabolicity": "Non parabolic correction to conduction band factor in 1/eV",
    "valley_degeneracy": "Degeneracy of each conduction band valley.",
    "hole_effective_mass": "Hole effective mass along the confinement direction [0]",
    "Valence band Non-parabolicity": "Non parabolic correction to valence band factor in 1/eV",
    "hole_valley_degeneracy": "Degeneracy of valence band valleys.",
    "mhDOS": "Hole density of states factors. [m0]",
    "permittivity": "Relative permittivity of the material [\varepsilon0].",
    "bandgap": "Bandgap energy [eV].",
    "deltaEc": "Conduction band offset with respect to the channel [eV].",
    "Doping_NA": "Acceptor doping concentration (m^-3).",
    "Doping_ND": "Donor doping concentration (m^-3)."
}

# --------------------------------------
# Default Values for Input files
# --------------------------------------
file1_defaults = {
    "EXECUTABLE_PATH":"/home/kash/Desktop/1D_EDR_CAD-main/",
    "OUTPUTFILE_LOCATION": "/home/kash/Desktop/1D_EDR_CAD-main/Results/",
    "TEMPERATURE": "300",
    "eQUANTUM_CORRECTION": "0",
    "hQUANTUM_CORRECTION": "0",
    "NO_OF_VALLEYS": "1",
    "NO_EIGEN_PER_VALLEY": "5",
    "MESH_SPATIAL_DISTANCE_m": "0.25e-9",
    "NO_OF_DOMAINS": "3 2.0e-09 10.0e-09 2.0e-09",
    "DAMPING": "0.1",
    "POISSON_TOL": "1E-3",
    "MAX_ITERATIONS": "1500",
    "SYMMETRIC_DOUBLE_GATE": "YES",
    "GATE_BIAS": "0 0.1 0",
    "BACK_GATE_BIAS": "0 0.1 0",
    "WORKFUNCTION_DIFF": "-0.9942",
    "MATLAB_RUNTIME": "/home/kash/MATLAB"
}

# --------------------------------------
# Default Values for Domain Parameters
# --------------------------------------
file2_defaults = {
    "Material_filename": "Mat1.txt",
    "material_type": "oxide",
    "effective_mass": "0.5",
    "meDOS": "0",
    "Conduction band Non-parabolicity": "0",
    "valley_degeneracy": "2",
    "hole_effective_mass": "0.2",
    "valence band non-parabolicity": "0",
    "hole_valley_degeneracy": "2",
    "mhDOS": "0",
    "permittivity": "3.9",
    "bandgap": "8.0",
    "deltaEc": "5.0",
    "Doping_NA": "0.0",
    "Doping_ND": "0.0"
}

# --------------------------------------
# Function to Save a File
# --------------------------------------
def save_file(data_dict, OutputFileLocation, title="Save As"):
    file_path = OutputFileLocation
    if file_path:
        with open(file_path, "w") as f:
            for key, val in data_dict.items():
                if (key == "Material_filename"):
                    continue
                elif (key == "EXECUTABLE_PATH"):
                    continue
                f.write(f"{key}:{val};\n")
        messagebox.showinfo("Saved", f"File saved successfully:\n{file_path}")

# --------------------------------------
# Function to Run Simulation
# --------------------------------------
def RunSimulation(param, ExePath, OutFolder):
    
    # Temporarily Copy the executable and the shell script the FileFolder
    command = "cp " + ExePath + "main " + OutFolder
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()

    command = "cp " + ExePath + "run_main.sh " + OutFolder
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()
    
    os.chdir(OutFolder)
    command = "./run_main.sh " + param + "> output"
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()

    command = "rm run_main.sh main"
    process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    process.wait()

# --------------------------------------
# Material File Window
# --------------------------------------
def open_MaterialFile_window(OutputFileLocation):
    file2_window = tk.Toplevel()
    file2_window.title("Material File")
    file2_window.geometry("400x600")

    entries = {}
    row = 0
    for key, val in file2_defaults.items():
        tk.Label(file2_window, text=key).grid(row=row, column=0, sticky="w", padx=5, pady=3)
        entry = tk.Entry(file2_window, width=40)
        entry.insert(0, val)
        entry.grid(row=row, column=1, padx=5, pady=3)
        entries[key] = entry
        
        # Add tooltip
        if key in file2_tooltips:
            CreateToolTip(entry, text=file2_tooltips[key])
        row += 1

    
    def save_MatPara(OutputFileLocation):
        MatFilename = entries['Material_filename'].get()
        print(MatFilename)
        updated_values = {k: e.get() for k, e in entries.items()}
        save_file(updated_values, OutputFileLocation+MatFilename, title="Save Material Data")
    
    tk.Button(file2_window, text="Save Material Parameters", command=lambda: save_MatPara(OutputFileLocation), bg="#FFFACD").grid(
        row=row, column=0, columnspan=2, pady=10
    )
    tk.Button(file2_window, text="Exit", command=file2_window.destroy, bg="#f08080").grid(
        row=row+1, column=0, columnspan=2, pady=10
    )

# --------------------------------------
# Main Window (InputFile.txt)
# --------------------------------------
def main_window():
    root = tk.Tk()
    root.title("Simulation Configuration")
    root.geometry("500x700")

    tk.Label(root, text="Input Parameters", font=("Arial", 14, "bold")).pack(pady=10)

    frame = tk.Frame(root)
    frame.pack()

    entries = {}
    for i, (key, val) in enumerate(file1_defaults.items()):
        tk.Label(frame, text=key).grid(row=i, column=0, sticky="w", padx=5, pady=3)
        entry = tk.Entry(frame, width=45)
        entry.insert(0, val)
        entry.grid(row=i, column=1, padx=5, pady=3)
        entries[key] = entry
        
        # Add tooltip
        if key in file1_tooltips:
            CreateToolTip(entry, text=file1_tooltips[key])

    def save_InpPara(OutputFileLocation):
        updated_values = {k: e.get() for k, e in entries.items()}
        save_file(updated_values, OutputFileLocation, title="Save Simulation Paramters File ")
    # Buttons
    tk.Button(root, text="Save InputFile", command=lambda: save_InpPara (entries['OUTPUTFILE_LOCATION'].get()+"InputFile.txt"), bg="#FFFACD").pack(pady=8)
    tk.Button(root, text="Generate Material File", command=lambda: open_MaterialFile_window(entries['OUTPUTFILE_LOCATION'].get()), bg="#c2f0c2").pack(pady=8)
    tk.Button(root, text="Run Simulation", command=lambda: RunSimulation (entries['MATLAB_RUNTIME'].get(), entries['EXECUTABLE_PATH'].get(), entries['OUTPUTFILE_LOCATION'].get()), bg="#add8e6").pack(pady=8)
    tk.Button(root, text="Exit", command=root.destroy, bg="#f08080").pack(pady=8)

    root.mainloop()


if __name__ == "__main__":
    main_window()
