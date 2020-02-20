---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.3.3
  kernelspec:
    display_name: simon
    language: python
    name: simon
---

```python
import numpy as np
from scipy import interpolate
import matplotlib.pyplot as plt

plt.xkcd()
rcParams = plt.rcParams
font_size = 14
rcParams["font.size"] = font_size
rcParams["axes.labelsize"] = font_size
rcParams["xtick.labelsize"] = font_size
rcParams["ytick.labelsize"] = font_size
rcParams["legend.fontsize"] = font_size
```

```python
# Raw data
y1 = np.array(
    [1, 1, 2, 1, 1, 1, 2, 10, 12, 10, 9.5, 8.5, 7.5, 7, 5, 4, 3, 2, 1, 2, 1, 1, 1]
)
x1 = np.linspace(0, 50, len(y1))
y2 = np.array([1, 1, 2, 1, 1, 1, 2, 10, 5, 2, 1, 2, 1, 1.5, 1, 1.5, 1, 1, 1, 2, 1, 2])
x2 = np.linspace(0, 50, len(y2))

# Smooth the data
tck1 = interpolate.splrep(x1, y1, s=0)
x_spline1 = np.linspace(min(x1), max(x1), 300)
y_spline1 = interpolate.splev(x_spline1, tck1, der=0)
tck2 = interpolate.splrep(x2, y2, s=0)
x_spline2 = np.linspace(min(x2), max(x2), 300)
y_spline2 = interpolate.splev(x_spline2, tck2, der=0)


%matplotlib widget
fig, ax = plt.subplots(figsize=(10, 6))
plt.plot(x_spline1, y_spline1, x_spline2, y_spline2)
plt.tick_params(
    axis="both",
    which="both",
    bottom=False,
    left=False,
    labelbottom=False,
    labelleft=False,
)
ax.axhline(1.5, linestyle="--", color="grey")
# ax.axvline(13, linestyle="--", color="grey")
plt.text(2, 2, "Baseline", fontdict={"color": "grey"})
fifty_line = plt.Line2D([14, 24], [5, 5], color="r", marker="|")
ax.add_line(fifty_line)
plt.text(18, 5.5, "50%", fontdict={"color": "r"})
plt.show()
```
