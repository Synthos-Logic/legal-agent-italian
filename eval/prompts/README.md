# Libreria prompt

- Prompt a versioni pinnate, definiti e congelati prima di osservare qualunque output del modello oggetto del test (GLM); nessun adattamento al modello.
- Per ogni task: prompt canonico + set di parafrasi semanticamente equivalenti (misura di stabilità).
- Ogni prompt è un file versionato; le run in `../runs/` referenziano il file e la sua versione (hash git).
