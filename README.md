# Infra-cloud-gke

# Soubscription à l'offre GCP de Google

![image](https://user-images.githubusercontent.com/78741748/216839436-3efd8672-ebeb-481e-97c0-522026b6b1e1.png)


# Déploiement de GKE à l'aide de terraform

Le dossier "terraform" contient les fichiers utilisés pour le déploiement du cluster avec les caractéristique suivantes:

- création d'un VPC dédié dans le Cloud
    - Le nom du VPC sera comme tel : "arouna-gke-vpc"
    - Le sous réseaux dédié dans ce VPC dont la plage d'adressage du sous réseaux est : "10.10.0.0/24"
    - Le nom du sous réseaux sera : "arouna-gke-subnetwork"


- La création du Pool d'instances Worker Kubernetes:
    - Nombre de noeuds : 2
    - Supprimer le Pool par default
    - Ce pool sera dans le sous réseaux créé dans le VPC
    - Type d'instance Google : "e2-standard-2"
    

VPC

![image](https://user-images.githubusercontent.com/78741748/216840154-b016c767-83cd-4d16-a659-8e853fe0adbf.png)



Cluster


![image](https://user-images.githubusercontent.com/78741748/216840599-34c1f423-8fd2-4581-b142-434d079167cd.png)
    
    
Node pool


![image](https://user-images.githubusercontent.com/78741748/216820168-e101544b-c4fa-416b-b32b-d8a6180925c1.png)


    
![image](https://user-images.githubusercontent.com/78741748/216840732-618f43ac-2bfe-4ff3-9cdc-e0f04e579267.png)


![image](https://user-images.githubusercontent.com/78741748/216840302-8d825dc9-c8af-4264-8d1f-945fe2e8ed78.png)


![image](https://user-images.githubusercontent.com/78741748/216840320-5e18c4fe-1145-4fdc-a08d-52acfbe80ecd.png)



# 1. Dockeriser cette stack

Téléchargement du répertoire de l'application "voting-app"
/: git clone  https://github.com/...
fgg

Création d'un namespace
kubectl create namespace vote



# 2. Création des fichiers de déploiement et service

Builder les images à partir des codes source contenus dans les différents dossiers

![image](https://user-images.githubusercontent.com/78741748/216818983-4a189463-08a2-4ff2-997c-485678a3a622.png)

Résultat:

![image](https://user-images.githubusercontent.com/78741748/216819235-8bfe2be2-352e-4acd-82e5-a967caba3665.png)


Après les build, il faut tagger les images et les envoyer dans le docker hub

> docker tag infra-cloud-gke-worker:latest arins007/votingapp:worker

> docker push arins007/votingapp:worker




# Déploiement des services


![image](https://user-images.githubusercontent.com/78741748/216826788-836d890e-7ca4-4757-b143-bde63c7c5a4e.png)



# 3. Vérification de l'accès à l'application depuis l'extérieur


Exposer les services vote et result à l'exterieur



Accès au service vote depuis l'extérieur via l'adresse http://35.245.239.198:5000/


![2023-02-04_17h15_26](https://user-images.githubusercontent.com/78741748/216778352-3070dc8e-a71f-4a6d-a708-9432a8c11b20.png)


Accès au service result depuis l'extérieur via l'adresse http://34.86.26.21:5001/
image.png


![2023-02-04_17h13_36](https://user-images.githubusercontent.com/78741748/216778372-6cc9a9e7-aac2-4b42-b39e-bb6f552ddb85.png)




# Partie GitOps

# 1. Installation de ArgoCD
Création d'un namespace
kubectl create namespace argocd

Télécharger et appliquer le fichier d'installation d'ArgoCD
> kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Vérification de l'état des pods
> kubectl get all -n argocd


![image](https://user-images.githubusercontent.com/78741748/216827930-80156dc3-be11-4a41-8be7-d9bc09366352.png)


Dépuis la console GCP

![image](https://user-images.githubusercontent.com/78741748/216829452-454b74e0-bca0-435e-b3c0-a9e40cd42167.png)




# Exposition du port au service et transfert vers l'hôte local

> kubectl port-forward svc/argocd-server -n argocd 8080:443


Accéder à ArgoCD via l'adresse  https://localhost:8080/

![](2023-02-05-00-01-22.png)


Le login par défaut est:      "admin"

Pour le mot de passe il faut rentrer la commande suivante pour l'obtenir

> kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

==> résultat:  0XUdqTOqEZErItY0

Utilisons les identifiants pour la connexion à ArgoCD

login: admin

password:  0XUdqTOqEZErItY0



![](2023-02-04-23-57-39.png)






Installation de ArgoCD CLI sur Windows (Powershell)

> choco install argocd-cli



Connexion à ArgoCD

> kubectl get service argocd-server -n argocd --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'


argocd login $(kubectl get service argocd-server -n argocd --output=jsonpath='{.status.loadBalancer.ingress[0].ip}') --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --insecure


![image](https://user-images.githubusercontent.com/78741748/216818353-15ae0808-9900-42a5-b0ee-c8c7a55e78ae.png)


# Ajout du repos Git

> argocd repo add git@github.com:ArinsF/Infra-cloud-gke.git --ssh-private-key-path ~/.ssh/id_rsa


![image](https://user-images.githubusercontent.com/78741748/216827401-d0d06584-a987-4d06-8fc8-02b8531124dd.png)


Création de l'application sur la console ArgoCD


![image](https://user-images.githubusercontent.com/78741748/216829006-5df9cdf7-366d-4ddd-8c72-3abca54b88da.png)




![image](https://user-images.githubusercontent.com/78741748/216829036-2829625f-01fd-4c1b-838d-29d32c44be4a.png)




