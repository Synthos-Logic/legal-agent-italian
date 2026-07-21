# Libreria prompt

- Stessi prompt, versioni pinnate, per entrambi i modelli (Kimi K2.6 e Claude baseline) sullo stesso harness.
- Per ogni task: prompt canonico + set di parafrasi semanticamente equivalenti (misura di stabilità).
- Ogni prompt è un file versionato; le run in `../runs/` referenziano il file e la sua versione (hash git).
