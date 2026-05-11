"""Local equivalent of the server-provided implant.py — uses numpy instead of
pandas (so it runs on this machine without an extra install) and saves a PNG
instead of opening an interactive window. Plot content/labels are identical to
the course's script."""
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# Load the CSV files
file1 = "implantAs.out"
file2 = "implantB.out"
file3 = "implantSb.out"
file4 = "implantP.out"

def load(f):
    a = np.loadtxt(f, delimiter="\t")
    # de-duplicate the boundary row
    _, idx = np.unique(a[:, 0], return_index=True)
    a = a[np.sort(idx)]
    return a[:, 0], a[:, 1]

x1, y1 = load(file1)
x2, y2 = load(file2)
x3, y3 = load(file3)
x4, y4 = load(file4)

plt.figure(figsize=(10, 6))
plt.plot(x1, y1, label="Arsenic", color="k")
plt.plot(x2, y2, label="Boron", color="g")
plt.plot(x3, y3, label="Antinomy", color="r")
plt.plot(x4, y4, label="Phosphorus", color="b")
plt.yscale("log")
plt.ylim(bottom=1e14)
plt.xlabel("Depth [um]")
plt.ylabel("Concentration [cm-3]")
plt.title("Implantation profiles")
plt.legend()
plt.grid(True, which="both", ls="--")
plt.savefig("plots/step04_implant_py.png", dpi=140)
print("saved plots/step04_implant_py.png")
