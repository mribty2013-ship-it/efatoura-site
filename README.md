# Site vitrine eFatoura — efatoura.ma

Site statique (HTML, CSS, JavaScript), publié par GitHub Pages sur **efatoura.ma**
(`e-fatoura.ma` redirige vers `efatoura.ma`).

- `index.html` : accueil (écrit directement).
- `_src/pages/*.html` : contenu des autres pages ; `_src/layout.html` : en-tête et pied de page communs.
  Après modification : `powershell -ExecutionPolicy Bypass -File _src\build.ps1`, puis commit et push.
- `assets/` : styles, script, logo et captures de l'application.
- L'installeur Windows est publié dans les *Releases* de ce dépôt (lien de la page Télécharger).

## DNS (zone gérée chez Nindohost)

| Domaine | Type | Nom | Valeur |
|---|---|---|---|
| efatoura.ma | A | @ | 185.199.108.153 |
| efatoura.ma | A | @ | 185.199.109.153 |
| efatoura.ma | A | @ | 185.199.110.153 |
| efatoura.ma | A | @ | 185.199.111.153 |
| efatoura.ma | CNAME | www | mribty2013-ship-it.github.io. |
| e-fatoura.ma | A | @ | les 4 mêmes adresses que ci-dessus |
| e-fatoura.ma | CNAME | www | mribty2013-ship-it.github.io. |

Ne pas toucher aux enregistrements MX (messagerie contact@efatoura.ma).
Quand les domaines répondent : GitHub › Settings › Pages › cocher « Enforce HTTPS » sur les dépôts
`efatoura-site` (efatoura.ma) et `efatoura-redirect` (e-fatoura.ma → efatoura.ma).
