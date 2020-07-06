# AbiWord Lambda Layer 
<img align="right" width="100" height="100" src="https://img.utdstc.com/icons/abiword-2-8-2.png:225">

This projects creates an AWS lambda layer that contains Abiword documents converter utilities. 
Similar projects exist, such as [LibreOffice for AWS Lambda as a layer](https://github.com/shelfio/libreoffice-lambda-layer), but often LibreOffice does not have optimal results in converting _doc_ and _docx_ format documents, especially in cases of files with tabular structures or graphic components.
This layer allows the addition of more accurate conversion functionality to your lambda functions.
For now it has only been tested for conversion from _doc_ and _docx_ to _PDF_ format.

## Build and deploy


```
# Build layer
./build.sh

# Deploy with serverless framework
sls deploy
```

