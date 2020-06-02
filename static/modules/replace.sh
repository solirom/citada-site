for i in *.xml
do
	sed -e 's# xmlns="http://www.loc.gov/mods/v3"##g' "$i" > ./tmp/"$i"
done
