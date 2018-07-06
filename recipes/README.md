To build a recipe, e.g. Abinit:

1. Edit the meta.yaml file (bump version, update requirements if needed)

2. Build the recipe with:

        conda build abinit --user=abinit

3. Upload to the abinit channel on the anaconda cloud with conda upload.