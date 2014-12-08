# Node.js WebApp

## Functionalities

* Sign in form :  accept username and email
* Sign up form :
    * username, email, password, and re-password, firstname, lastname
    * Server validation and client optionnel (AJAX, Pretty display and message)
* Import / Export csv + json

## Layout


## Signin / Signup form
If user is already logged in, he musr arrive ont its homepage (not on signin or signup screen)

## LevelDB schema
- décrire clé comment elles sont nommés
- décrire les valeurs (strin, int, name etc.)

## Import / Export
Create 2 commands './bin/import' and './bin/export'. Each commands take 2 arguments "--help" and "--format".
--help: display help
--format: format of the file

### Import & Export
For a simple argument parse, you may use [minimist]. For a more complex parser, you may user [parameters].

### Import
'''
./bin/import --help
Introduction message
import [--help] [--format {name}] output
--help Print this message
--format {name} One of csv(default) or json
'''

### Export
'''
./bin/export --help
Introduction message
import [--help] [--format {name}] output
--help Print this message
--format {name} One of csv(default) or json
'''

Import must implemented "stream.Writable" class inside a module './lib/import'. Here's an example on how to use the import module:

'''
(Fichier js)
import = require './lib/import'
db = require './lib/db'
client = db './db'

fs
.createReadStream('./sample.csv')
.pipe import client, format:'csv'

(import: fichier coffee)
'''

Export must implemented "stream.Readble" class inside a module './lib/export'. Here's an example on how to use the export module:

'''
(Fichier js)
import = require './lib/export'
db = require './lib/db'
client = db './db'

export(client, format:'csv')
.pipe fs.createReadStream('./sample.csv')

(export: fichier coffee)
'''

# DEADLINE : 20 decembre !!!!!!!!
# TODO
* Comlepter le signup & bdd
* validation erreur : password - re-password, pas déjà entrer etc.
* import / export json
  * Type
  [
    { username: "toto" },
    { password: "titi"}
  ]
  * parseur sax : envoie / reçoit infos au fur à mesure: charge pas tous en mémoire récupère les évenements au lieu de tous charger en mémoire d'un coup => flux continu
  * ou fait son propre parseur : enlève [], et "," et fait 1 ligne - 1 Objet
  * inconvenient json : que encodage utf-8
  * Lancement en ligne de commande et non dans le site
  * pour pouvoir lancer le fichier js changer  chmod +x bin/import.js
  * Libraie pour argument: https://github.com/substack/minimist
* completer le readme : lancer serveur / lancer import / export
* test import / export
* finir les test (lancer npm test)
* revoir l'import / export
* Stocker la session côté serveur: si rafraichit page et qu'il s'est déjà connecté alors fait cmd+r doit rester sur le home page et non signin
Regarde dans index.jade si session existe et si oui affiche dahsboard et non signin: https://www.npmjs.org/package/express-session
* Export: écrire en continu dans le fichier (à chaque lecture d'un user: appeler writable ? à voir)

## List
1. Import / Export (format, ligne de commandes)
2. BDD: ajout des champs & modifie signup avec validation
3. Gestion des sessions pour garder la connection
4. Test : ajouter import / export & réparer + app (service rest, formulaire, regarder sur npm comment tester serveur web - 3 requetes?)
  * index avec email / username
  * requetes http (pas pilotage interface) : web service
  * web service: requete sign in (username, mail), sign up,
    * localhost:1337/ => gestion des post
    * Simulteur des requetes post: crawler : create new crowler: code 200 : sans erreur
5. Completer le readme
  * structure projet
  * lancement app, export, import
  * comment lancer les tests : commande
  * mettre schema bdd (user & clé mail))
  * ajouter nos mails : contributors : ... tout en bas readme
  Contributors
  -----------
  * xxx : mail <mail> ou <https://github.com/nom>
  * xxxx
6. Structure vérifier: ajouter .npmignore


# TODO POUR RENDU FINAL
sauvegarder les log de l'user activité à chaque fois qu'il se log "timestamp"
Supprime quand supérieur à une date
quand il se log: afficher tableau avec son ip ou localisation ou ensemble page visité & afficher en tableau sur dashboard quand il est logué



## Créer projet
git init
readme
licence

créer package.json

.npmignore: meme chose que le git + librairie npm
