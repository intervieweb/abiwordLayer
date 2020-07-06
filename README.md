# AbiWord Lambda Layer 
<img align="right" width="100" height="100" src="https://www.google.com/url?sa=i&url=https%3A%2F%2Fprocesadordetexto.wordpress.com%2Fabiword%2F&psig=AOvVaw1L9FGvbnKa7SZmufF56cu9&ust=1594127607185000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCID44p_auOoCFQAAAAAdAAAAABAd">

This projects creates an AWS lambda layer that contains Abiword documents converter utilities. 
Similar projects exist, such as [LibreOffice for AWS Lambda as a layer](https://github.com/shelfio/libreoffice-lambda-layer), but often LibreOffice does not have optimal results in converting _doc_ and _docx_ format documents, especially in cases of files with tabular structures or graphic components.
This layer allows the addition of more accurate conversion functionality to your lambda functions.
For now it has only been tested for conversion from _doc_ and _docx_ to _PDF_ format.

## Build and deploy

After Dockerfile build

```
# Build layer
./build.sh

# Deploy with serverless framework
sls deploy
```

