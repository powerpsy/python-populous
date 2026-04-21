# build.ps1


# Demande le commentaire de commit et le numéro de version
$commitMsg = Read-Host "Entrez le commentaire de commit"
$versionTag = Read-Host "Entrez le numéro de version (ex: v1.2.3)"


# Vérifie que populous.py existe
if (!(Test-Path "populous.py")) {
    Write-Host "Erreur : populous.py introuvable dans le dossier courant."
    exit 1
}

# Ajoute tous les changements
git add .

# Commit avec le message personnalisé
git commit -m "$commitMsg"

# Push sur la branche principale
git push origin main

# Création et push du tag de version
if ($versionTag -ne "") {
    git tag $versionTag
    git push origin $versionTag
    Write-Host "Tag de version créé : $versionTag"
}

Write-Host "Push effectué. Le workflow GitHub Actions va compiler les exécutables sur les 3 plateformes."
Write-Host "Vérifie l'onglet 'Actions' sur GitHub pour suivre la compilation et télécharger les artefacts."