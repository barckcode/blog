# Personal website of Barckcode

# Steps for production:
git clone https://github.com/BarckCode/app.git barckcode.dev
ansible-playbook -t install_pip_packages main_playbook.yml
python3 app.py
gunicorn app:app -b localhost:8000 &
- Create a supervisor file
- Create a VirtualHost file