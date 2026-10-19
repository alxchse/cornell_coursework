# CHEME 4800/5800 Fall 2026: Week 03

Stacks, queues, recursion, and sorting as a testable algorithm

This is the student bundle for release `week-03.2`. Start from this directory, which
contains the pinned Julia environment used by every included notebook.

## Before you open a notebook

1. Extract this ZIP completely and keep the extracted folder somewhere you can
   edit it. Do not run notebooks from inside the ZIP.
2. Install Julia 1.12 with
   [`juliaup`](https://github.com/JuliaLang/juliaup), then check that
   `julia --version` reports a `1.12` release.
3. Install [VS Code](https://code.visualstudio.com/download). In its Extensions
   view (`Ctrl+Shift+X` on Windows/Linux or `Cmd+Shift+X` on macOS), install both
   [**Julia** by julialang](https://marketplace.visualstudio.com/items?itemName=julialang.language-julia)
   (`julialang.language-julia`) and
   [**Jupyter** by Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-toolsai.jupyter)
   (`ms-toolsai.jupyter`). Reload VS Code if prompted.
4. In VS Code, choose **File > Open Folder** and select this top-level extracted
   folder—not an individual meeting folder or notebook. You have the correct folder
   when `Project.toml`, `Manifest.toml`, `README.md`, and `weeks/` are visible in
   the Explorer sidebar.
5. Choose **Terminal > New Terminal** and run:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.instantiate()'
   julia --project=. -e 'using VLDataScienceMachineLearningPackage; println("SETUP-OK")'
   ```

The first command may spend several minutes downloading and precompiling packages
on a new machine. Let it finish; later starts are much faster. `SETUP-OK` confirms
that the course environment is ready.

## Run a notebook

1. Open the [Week 03 guide](weeks/week-03/README.md) and choose the notebook for the class
   meeting. You can find it in the VS Code Explorer under `weeks/week-03`.
2. Open the `.ipynb` file. Click **Select Kernel** in the upper-right corner and
   choose **Julia 1.12**.
3. Run the first code cell, which loads the meeting's `Include.jl`, and then run
   the remaining cells in order with the cell run button or `Shift+Enter`.

A tan or yellow package-precompilation notice is informational, not a failure. If
**Julia 1.12** does not appear in the kernel picker, confirm that both VS Code
extensions are enabled, rerun the setup commands, and restart VS Code. If the
notebook has no run buttons, the Jupyter extension is missing or disabled. If a
package cannot be loaded, confirm that the VS Code terminal is in the top-level
folder containing `Project.toml` and repeat the setup commands. Bring the exact
error message to office hours if the problem continues.
