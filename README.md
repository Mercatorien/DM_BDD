```yaml
Nicolas Massot, Bases de données géographiques
```

# Évaluer les impacts écologiques des lieux du spectacle ?

## Étude des îlots de chaleur urbains pendant le Festival IN d'Avignon (juillet 2025)

Accéder au dépôt [GitHub](https://github.com/Mercatorien/DM_BDD/) <br>
Dump de la base : [Proton Drive](https://drive.proton.me/urls/53NYFJ9H58#31iN0GC80pBA)

## 1. Contextualisation

Le Festival d'Avignon est la plus importante manifestation de théâtre et de spectacle vivant du monde, par le nombre de créations et de spectateurs réunis. Il se déroule chaque année au mois de juillet. Cependant, le changement climatique menace sa tenue. En effet, avec des températures allant au-delà des 40°C, les festivaliers sont de plus en plus dans une situation d'inconfort thermique, lui-même exacerbé par une multitude de facteurs.

<table>
  <thead>
    <tr>
      <th>Catégorie</th>
      <th>Facteurs principaux</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Structure urbaine</td>
      <td>
        <ul>
          <li>Matériaux minéraux (bitume, béton)</li>
          <li>Faible albédo</li>
          <li>Morphologie des rues (canyon urbain)</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Absence de végétation</td>
      <td>
        <ul>
          <li>Sols imperméables</li>
          <li>Peu d'espaces verts</li>
          <li>Évapotranspiration réduite</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Activités humaines</td>
      <td>
        <ul>
          <li>Trafic routier et industries</li>
          <li>Chauffage et climatisation</li>
          <li>Pollution atmosphérique</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Facteurs climatiques</td>
      <td>
        <ul>
          <li>Vents faibles</li>
          <li>Faible humidité</li>
          <li>Ciel dégagé la nuit</li>
        </ul>
      </td>
    </tr>
    <tr>
      <td>Facteurs temporels</td>
      <td>
        <ul>
          <li>Cycle jour/nuit</li>
          <li>Croissance urbaine rapide</li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>
</div>

L'objectif est donc de recenser les théâtres du Festival d'Avignon IN pour 2025 en incluant des attributs descriptifs, ainsi que leur localisation, et ensuite, d'étudier la thermographie de surface en séries temporelles allant de 2013 à 2025. Ces informations serviront ensuite pour créer un outil d'aide à la décision dédié aux décideurs du Festival d'Avignon, dans l'objectif, par exemple, de s'inspirer des théâtres les plus frais pour aménager les théâtres les plus chauds.

Cette base de données est créée de toute pièce spécifiquement pour ce travail, et dans l'optique de répondre aux besoins métiers du Festival d'Avignon.

## 2. Modèle logique de données

La base de données est composée de quatre tables (dont une pour des données raster), une vue et une vue matérialisée.

Premièrement, la table `THEATRE` représente les 35 théâtres qui ont accueillis au moins un spectacle lors du Festival d'Avignon IN 2025. Elle est composée de différents attributs descriptifs, dont la capacité d'accueil et la géolocalisation.

La table des `SPECTACLE` représente les œuvres artistiques.

Il y a une relation n:n entre les théâtres et les spectacles. Un théâtre accueille plusieurs spectacles, et un spectacle peut se jouer dans plusieurs théâtres. De ce fait, il y a une table de relation nommée `R_SPECT_DATE` entre les deux, qui décrit une représentation théâtrale, à un lieu donné et à un moment donné.

Avec ces trois tables, nous créons la vue `THEATRE_AVEC_SPEC` dans laquelle nous ajoutons le nombre de représentations théâtrales pour chaque théâtre. Nous connaissons la capacité d'acceuil de chaque théâtre. Ainsi, pour calculer l'affluence des théâtres pendant l'entièreté du Festival d'Avignon 2025, on suppose un taux de fréquentation de 100% : $nb\_pers\_acc = capacite * nb\_spectacles$.

Nous choisissons de créer une vue simple pour cette table, car elle ne nécessite pas beaucoup de ressources à calculer, dans la mesure où on sélectionne les attributs de la table THEATRE, et nous faisons une simple multiplication.

Ensuite, pour étudier la température, nous traitons des images Landsat 8 pour extraire la thermographie de surface à l'aide d'un [script R](https://github.com/Mercatorien/DM_BDD/blob/6470ee20f6e7705b2d81bfbd3ff35cbab2b36039/R/CALCUL_LST.R). Il permet de calculer pour chaque année, un raster qui décrit la température de surface. Nous mettons ces données dans la table **LST** (*Land Surface Temperature*). Cette table contient une image par année entre 2013 et 2025, prises aux dates suivantes (autour de juillet)

2013-07-30
2014-07-17
2015-07-20
2016-07-06
2017-08-26
2018-07-12
2019-07-31
2020-07-01
2021-07-20
2022-07-31
2023-07-26
2024-07-28
2025-06-21

Ainsi, on peut prélever les valeurs des rasters vers les entités ponctuelles des théâtres avec `ST_Value()` . On stocke ces valeurs dans la vue matérialisée **THEATRE_LST_SERIE**, où une entité représente un théâtre à une année donnée ainsi que la température associée.

Il y a une relation d'intersection entre les LST.

Nous choisissons de faire une vue matérialisée dans la mesure où le prélèvement des valeurs des LST vers les points peut prendre du temps, surtout dans l'optique où la base est pensée pour être développée en continu avec des nouvelles données et des nouveaux théâtres.

Certaines contraintes sont également décrites dans le modèle logique de données.

Cette base de données permet d'assurer :

- La contrainte d'unicité (clés primaires)
  
- La contrainte d'intégrité référentielle (clés étrangères et cardinalités)
  
- L'atomicité
  

Toutes les tables sont indexées spatialement, et les tables les plus grosses ont indexées attributairement.

![](https://github.com/Mercatorien/DM_BDD/raw/8201b3e26cb148e60ae3e756e09fe97cd20ccd5c/MLD.png)

Le DDL est disponible ici : [DDL](https://github.com/Mercatorien/DM_BDD/blob/64c463221aacc5c111ec8c95a5687243d9c31f44/DDL.sql)

## 3. Exploitation de la base

### Carte

Avec la vue `THEATRE_AVEC_SPEC`, on a la possibilité de cartographier l'affluence dans les théâtres du Festival IN d'Avignon 2025 avec des cercles proportionnels.

Cette carte est obtenue par le code permettant de créer la vue `THEATRE_AVEC_SPEC`. Cette requête prend tous les théâtres (avec `LEFT JOIN`) et compte le nombre d'`id_s` (PK des spectacles). Ensuite, on multiplie ce résultat par la capacité, pour obtenir le nombre de personnes accueuillies.

```sql
CREATE OR REPLACE VIEW THEATRE_AVEC_SPECTACLE
 AS
 SELECT t.id_t,
    t.nom_t,
    t.adresse,
    t.site_internet,
    t.capacite,
    t.source_capacite,
    t.notes,
    t.x,
    t.y,
    t.geom,
    COALESCE(count(DISTINCT r.id_s), 0::bigint) AS nb_spectacles,
    COALESCE(t.capacite * count(DISTINCT r.id_s), 0::bigint) AS nb_pers_acc
   FROM theatre t
     LEFT JOIN R_SPECT_DATE r ON t.id_t = r.id_t
  GROUP BY t.id_t, t.nom_t, t.adresse, t.site_internet, t.capacite, t.x, t.y, t.source_capacite, t.notes, t.geom;

ALTER TABLE THEATRE_AVEC_SPECTACLE
    OWNER TO postgres;  
```

![](https://github.com/Mercatorien/DM_BDD/raw/8201b3e26cb148e60ae3e756e09fe97cd20ccd5c/CARTE.png)

### Requêtes

Trois requêtes intéressantes réalisables avec cette base de données.

#### Top 10 des spectacles les plus joués

```sql
SELECT
    s.nom AS spectacle,
    COUNT(r.id_r) AS nb_representations
FROM R_SPECT_DATE r
JOIN SPECTACLE s ON r.id_s = s.id_s
GROUP BY s.nom
ORDER BY nb_representations DESC
LIMIT 10;
```

#### Le jour le plus chaud pour chaque théâtre

```sql
SELECT DISTINCT ON (tls.id_theatre)
    tls.id_theatre,
    t.nom_t as theatre,
    tls.date_lst,
    tls.temp
FROM THEATRE_LST_SERIE tls
JOIN THEATRE t ON t.id_t = tls.id_theatre
ORDER BY tls.id_theatre, tls.temp DESC;
```

#### Relation entre la température et l’activité du théâtre

```sql
WITH temp_moy AS (
    SELECT 
        tls.id_theatre,
        AVG(tls.temp) AS temp_moy
    FROM THEATRE_LST_SERIE tls
    GROUP BY tls.id_theatre
)
SELECT 
    corr(temp_moy.temp_moy, tas.nb_pers_acc::float) AS coeff_correlation
FROM temp_moy
JOIN THEATRE_AVEC_SPECTACLE tas ON tas.id_t = temp_moy.id_theatre;
```

### R

Ensuite, pour exploiter plus profondément cette base de données, on la connecte à R, pour pouvoir faire des graphiques. [Code disponible ici](https://github.com/Mercatorien/DM_BDD/blob/8201b3e26cb148e60ae3e756e09fe97cd20ccd5c/R/EXPLOITATION_DONNEES.R).

Ce code permet de représenter sur un graphique l'évolution des températures entre 2013 et 2025 pour les théâtres. Ces derniers sont classé par ordre de température moyenne.

![](https://github.com/Mercatorien/DM_BDD/raw/64c463221aacc5c111ec8c95a5687243d9c31f44/GRAPHIQUES/theatre_LST_graphs.png)
