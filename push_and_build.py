# Script pour commit, push et lancer le workflow GitHub Actions
# À exécuter dans le répertoire du projet

import subprocess
import sys
import os

# Vérifie que populous.py existe
if not os.path.exists('populous.py'):
    print("Erreur : populous.py introuvable dans le dossier courant.")
    sys.exit(1)


# Saisie du message de commit et du numéro de version
version_tag = input("Version: ")
commit_msg = input("Commentaire de version: ")

# Ajoute tous les changements
subprocess.run(["git", "add", "."])

# Commit avec le message personnalisé
subprocess.run(["git", "commit", "-m", commit_msg])

# Push sur la branche principale
subprocess.run(["git", "push", "origin", "main"])

# Création et push du tag de version
if version_tag:
    subprocess.run(["git", "tag", version_tag])
    subprocess.run(["git", "push", "origin", version_tag])

print("Push effectué. Le workflow GitHub Actions va compiler les exécutables sur les 3 plateformes.")
print("Vérifie l'onglet 'Actions' sur GitHub pour suivre la compilation et télécharger les artefacts.")
print(f"Tag de version créé : {version_tag}")
