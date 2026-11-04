FROM quay.io/jupyter/scipy-notebook:latest

WORKDIR /home/jovyan/bd-a1

COPY --chown=jovyan:users requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=jovyan:users Data/ ./data/
COPY --chown=jovyan:users Data_&_Text_Analysis/ ./
COPY --chown=jovyan:users Figures/ ./figures/
COPY --chown=jovyan:users output/ ./outputs/

RUN mkdir -p data figures outputs

EXPOSE 8888

CMD ["start-notebook.py", "--ServerApp.ip=0.0.0.0"]
