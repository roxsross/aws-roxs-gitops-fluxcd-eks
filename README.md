# aws-demo-gitops-flux
Time to Demo [AWS Marathon]. Acelerando los flujos de trabajo en EKS con GitOps + Flux  by RoxsRoss

GitOps es un nuevo enfoque para la implementación continua que aprovecha Git como una única fuente de verdad para la infraestructura declarativa y las aplicaciones, proporcionando tanto control de revisiones como de cambios. Con GitOps, un sistema se ejecuta mediante el envío de solicitudes de extracción o “pull requests” (y combinaciones posteriores) para lograr el estado deseado del sistema representado en un repositorio de Git.

Con GitOps, se declara el estado deseado de los clústeres de Kubernetes en archivos en repositorios de Git. Los repositorios de Git pueden contener los siguientes archivos:

- Manifiestos en formato YAML que describen recursos de Kubernetes (como espacios de nombres, secretos, implementaciones, etc.)
- Helm para implementar aplicaciones
- Archivos de Kustomize para describir cambios específicos del entorno

En este tutorial se realizará la configuración de CI/CD con GitOps con Flux v2

Siguiendo la documentación de la pagina oficial: https://fluxcd.io/flux/get-started/

Nuestra arquitectura está formada por un pipeline en el que los desarrolladores y devops llevan a cabo el CI y luego confían en FluxCD como CD.

![Fluxcd](./assets/fluxcd.jpg)

El Pipeline tiene dos etapas principales:

Codigo : AWS CodeCommit almacena el repositorio de aplicaciones y el repositorio de infraestructura de Kubernetes. Un evento ocurre [Pull Request] en el repositorio de la aplicación y activa el pipeline.

Build_1 : AWS CodeBuild busca un security_buildspec.yaml para revisar vulnerabilidades de nuestra aplicación antes de proceder a la contrucción de la aplicacion.

Build_2 : AWS CodeBuild busca un buildspec.yaml para compilar y envía nuestra aplicación de contenedor a Amazon Elastic Container Registry (Amazon ECR).

![](./assets/codepipeline.png)

Material en Repositorio:

- Nuestras buildspec.yaml para revisión de vulnerabilidades con las tools [Horusec, Snyk, hadolint, trivy] y Contrucción de imagen Docker además push a ECR

[buildspec](./codebuild/resources/buildspec-build.yml)

- K8s Tools, Varias herramientas utiles para usar en Cloud9 o en un entorno local. 
    para instalar solo es necesario ./k8stools.sh *recuerden darle permiso de ejecución*
    [install](./k8stools/k8stools.sh)
    `chmod +x k8stools.sh`
    `sudo ./k8stools.sh install`

- Kustomize es una herramienta que nos sirve para “kustomizar” configuración de aplicaciones en Kubernetes, donde estaran las bases de nuestra demo
    [devfinder](./kustomize/apps.yaml)



Documentación de AWS Recomendada [Gitops](https://community.aws/tutorials/using-flux-to-implement-gitops-on-aws)



---
![](https://github.com/roxsross/roxsross/blob/main/images/roxsross-banner-1.png)

##### Nos Vemos 🔥🔥🔥🔥


---
---
<p align="left" width="100%">
  <br>
    <img width="20%" src="https://raw.githubusercontent.com/roxsross/roxsross/main/images/Copia de ROXSROSS FINAL (1).png"> 
</p>

⌨️ con ❤️ por [roxsross](https://github.com/roxsross) 😊

"No se trata de cambiar el mundo, creo que creas un cambio pequeño, pero que te importe estás cambiando las cosas".


[![site](https://img.shields.io/badge/Hashnode-2962FF?style=for-the-badge&logo=hashnode&logoColor=white&link=https://blog.295devops.com) ](https://blog.295devops.com)
[![Blog](https://img.shields.io/badge/dev.to-0A0A0A?style=for-the-badge&logo=devdotto&logoColor=white&link=https://dev.to/roxsross)](https://dev.to/roxsross)
![Twitter](https://img.shields.io/twitter/follow/roxsross?style=for-the-badge)
[![Linkedin Badge](https://img.shields.io/badge/-LinkedIn-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/roxsross/)](https://www.linkedin.com/in/roxsross/)
[![Instagram Badge](https://img.shields.io/badge/-Instagram-purple?style=for-the-badge&logo=instagram&logoColor=white&link=https://www.instagram.com/roxsross)](https://www.instagram.com/roxsross/)
[![Youtube Badge](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white&link=https://www.youtube.com/channel/UCa-FcaB75ZtqWd1YCWW6INQ)](https://www.youtube.com/channel/UCa-FcaB75ZtqWd1YCWW6INQ)