echo "generating tags"
python tag_gen.py
echo "fetching projects"
python repo_puller_json.py
echo "pushing to github"
gacp "chore: upd"