#########################################################################################
############################## Builds .rst files folderwise #############################
#########################################################################################
find . -not -name "*.sh" -delete
sphinx-apidoc -o . .. -T -f -M
find . -type f -name "*.rst" -exec basename {} \; | while read -r line;
do
    mkdir -p $(echo $line | sed -e 's/\./\//g' -e 's/\/rst//' -e 's/\/[^/]*$//') && touch $(echo $line | sed -e 's/\./\//g' -e 's/\/rst/.rst/')
    cp $line $(echo $line | sed -e 's/\./\//g' -e 's/\/rst/.rst/')
done
find . -type f -regex '.*\.[^.]*\.[^.]*\.[^.]*' -delete
find . -type d -empty -delete

#########################################################################################
##### Removes Module Documentation part, if you want it comment the below command #######
#########################################################################################
find . -type f -name '*.rst' -exec sh -c 'sed "3,7d" "{}" > tmpfile && mv tmpfile "{}"' \;

#########################################################################################
####### Removes heading(Subpackages), if you want it comment the below command ##########
#########################################################################################
find . -type f -name "*.rst" -exec sh -c 'sed "/Subpackages/,/^$/d" "{}" > tmpfile && mv tmpfile "{}"' \;

#########################################################################################
######## Removes heading(Submodules), if you want it comment the below command ##########
#########################################################################################
find . -type f -name "*.rst" -exec sh -c 'sed "/Submodules/,/^$/d" "{}" > tmpfile && mv tmpfile "{}"' \;

###########################################################################################################
######## Removes module at the end of each module name, if you want it comment the below command ##########
###########################################################################################################
find . -type f -name "*.rst" -exec sh -c 'sed "s/ module//g" "{}" > tmpfile && mv tmpfile "{}"' \;


#############################################################################################################
######## Removes package at the end of each package name, if you want it comment the below command ##########
#############################################################################################################
find . -type f -name "*.rst" -exec sh -c 'sed "s/ package//g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "/^\.\. automodule/!s/\./\//g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "/^\/\/ toctree/s/\//\./g" "{}" > tmpfile && mv tmpfile "{}"' \;
find . -type f -name "*.rst" -exec sh -c 'sed "/   /!s/.*\///g" "{}" > tmpfile && mv tmpfile "{}"' \;

#########################################################################################
############################# Updates relative path of .rst files #######################
#########################################################################################
find . -type f -name "*.rst" | while read -r line;
do
    echo $line | sed -e 's/\./\//g' -e 's/\/rst//' -e 's/\/[^/]*$//' -e 's/^..//' -e 's/\//\\\\\//g' | xargs -I {} echo "sed -i.bak 's/"{}"\///g'" $line | bash
    find . -name "*.bak" -delete
done

#########################################################################################
###################################### Sphinx Quickstart ################################
#########################################################################################
sphinx-quickstart
