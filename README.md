# SMS Spam Classification & Text Analytics

Dataset: **UCI SMS Spam Collection** (provided in `data/SMSSpamCollection` with its readme). Each TSV row is a single SMS, labeled `ham` or `spam`.

## Project contents
- `SMS_Spam_Analysis.ipynb`: numbered, runnable cells for sections 4–6.
- `analysis.py`: same end-to-end reproducible code (can run independently).
- `cleaned_data.csv`: deduplicated SMS with original and cleaned text and numerical features.
- `figures/`: saved PNG visualizations.
- `outputs/`: model metrics, clustering summary, execution log. Sampling distributions, frequency tables, and group comparisons are shown in the notebook rather than exported as CSV files.
- `data/`: raw source dataset and original description.
- `screenshots/`: where to save screenshots of commands on **your** computer (not fabricated).

## Run locally
From the project folder:

```bash
python -m venv .venv
# Windows: .venv\\Scripts\\activate
# Linux/Mac: source .venv/bin/activate
pip install -r requirements.txt
python analysis.py
jupyter lab
```
Open `SMS_Spam_Analysis.ipynb`, set its project folder as working directory, and run all cells. The notebook displays intermediate tables and saved charts inline. The script and notebook use the same analysis steps.

## Docker: build, images, run, mount
Requires Docker Desktop (Windows/macOS) or Docker Engine (Linux).

```bash
docker build -t sms-spam-analysis:latest .
docker images
# Persist output files in the current project folder using a bind mount:
docker run --rm -p 8888:8888 -v "${PWD}:/app" sms-spam-analysis:latest
```

PowerShell mount alternative:

```powershell
docker run --rm -p 8888:8888 -v "${PWD}:/app" sms-spam-analysis:latest
```

Windows CMD mount alternative:

```cmd
docker run --rm -p 8888:8888 -v "%cd%:/app" sms-spam-analysis:latest
```

Open http://localhost:8888/lab and run all notebook cells. The exposed server has authentication disabled **for local development only**; never expose port 8888 to an untrusted network. For non-Jupyter execution:

```bash
docker run --rm -v "${PWD}:/app" sms-spam-analysis:latest python analysis.py
```

## Docker Hub
Sign in with `docker login`, replace `YOUR_DOCKERHUB_USERNAME` with your own account name, then:

```bash
docker tag sms-spam-analysis:latest YOUR_DOCKERHUB_USERNAME/sms-spam-analysis:latest
docker push YOUR_DOCKERHUB_USERNAME/sms-spam-analysis:latest
docker pull YOUR_DOCKERHUB_USERNAME/sms-spam-analysis:latest
```

No image was actually pushed as part of preparing this ZIP.

## Reproduction and methodology
1. Install dependencies (or build the Docker image).
2. Run `python analysis.py` or use `SMS_Spam_Analysis.ipynb` (run all cells).
3. Inspect `cleaned_data.csv`, `figures/` and `outputs/`.
4. Results use random state 42. Exact results may vary somewhat across dependency versions or operating systems.
5. Raw CSV is TSV-style data. Remove repeated exact label-and-text pairs and any blank/invalid records. No labels are derived from the text. Preserve raw text, create `cleaned_text` separately. Replace URLs and numeric runs with placeholder words to retain signal.
6. Sampling methods: simple random rows, stratified label-proportion rows, and cluster sampling of *entire consecutive 100-record blocks*. Blocks are used as a pragmatic grouping because this dataset has no sender/location metadata. Original order may not be randomly representative: cluster estimates can be biased.
7. Four features: characters, token count, unique token count, average word length. Add encoding, length binning, and min-max normalization.
8. Supervised model uses an 80/20 stratified split **after deduplication**; fit the TF-IDF vocabulary only on training text to avoid train/test leakage.
9. K-Means groups SVD-normalized TF-IDF text with k=2 as an interpretable baseline; assess with sampled silhouette and Adjusted Rand Index (ARI). Labels are used only after clustering for comparison.

## Required screenshots: take on your computer
No Docker executable is available in the build environment used to prepare these files, so these screenshots cannot be supplied as proof. Capture and place in `screenshots/`:
1. `01_docker_build.png`: successful `docker build -t sms-spam-analysis:latest .` output.
2. `02_docker_images.png`: output of `docker images` with the image displayed.
3. `03_running_container.png`: terminal output showing running container and URL (or `docker ps`).
4. `04_jupyter_notebook.png`: JupyterLab with notebook executed and result cells visible.

## Caveats
Historical, English-heavy SMS; spam vocabulary may shift. Cluster ID 0 or 1 does not inherently identify spam. Correlation between engineered length variables is not causation. The original dataset is included under the terms described in the original UCI readme; check your course/institution redistribution policy before publishing.
