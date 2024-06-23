@echo off
echo generating tags
python tag_gen.py
rem echo "fetching projects"
rem python repo_puller_json.py
echo pushing to github
gacp "chore: upd"