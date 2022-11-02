# Use GHA deployment environments through workflows - 2022-11 

## Context

Since November 2022, the **deploy** workflow sampled in `.manala/github/deliveries/README.md` handles the creation of
GitHub deployments objects through the `jobs.environment` key instead of using the API from
the `.manala/github/deliveries/action.yaml`.

These deployments objects are used notably to trigger notifications on Slack and to expose the deployment URL in the
GitHub UI.

## Migrate

Simply update the recipe in your project and adapt the `.github/workflows/deploy.yaml` workflow according to the `.manala/github/deliveries/README.md` content.

The changes should look like:

```diff
         required: true
       tier:
         description: Tier
-        type: choice
-        options: [production, staging]
+        type: environment
         required: true
       ref:
         description: Git reference from the release repository. Do only provide to deploy another reference than the latest available version for the tier (deploy a previous release or a specific commit).

   deploy:
     name: Deploy ${{ github.event.inputs.app != '' && format('{0}@', github.event.inputs.app) || '' }}${{ github.event.inputs.tier }}
     runs-on: ubuntu-latest
+
+    environment:
+      name: ${{ github.event.inputs.tier }}
+      url: ${{ steps.deploy.outputs.deployment_url }}
+
     steps:
       - name: 'Checkout'
         uses: actions/checkout@v3
 
       - name: 'Deploy'
         uses: ./.manala/github/deliveries
+        id: deploy
         with:
           secrets: ${{ toJSON(secrets) }}
           app: ${{ github.event.inputs.app }}
           tier: ${{ github.event.inputs.tier }}
```
