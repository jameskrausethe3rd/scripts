import subprocess
import sys
from plexapi.server import PlexServer
import os
from dotenv import load_dotenv

load_dotenv()  # Load variables from .env

# Set working directory to the location of this script
script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

# Update these variables
PLEX_URL = os.getenv('PLEX_URL')
PLEX_TOKEN = os.getenv('PLEX_TOKEN')
LIBRARY_NAME = 'TV Shows'
JBOPS_SCRIPT_PATH = './hide_episode_spoilers.py'
BLUR_AMOUNT = 25

# Parse CLI arguments
mode = sys.argv[1] if len(sys.argv) > 1 else 'blur'

if mode not in ['blur', 'remove']:
    print("Usage: python blur_or_remove_all_shows.py [blur|remove]")
    sys.exit(1)

# Connect to Plex
plex = PlexServer(PLEX_URL, PLEX_TOKEN)
library = plex.library.section(LIBRARY_NAME)

# Get the show
shows = library.all()
print(f'Found {len(shows)} shows in "{LIBRARY_NAME}".')

for show in shows:
    # Call the JBOPS script with blur parameter
    print(f'Blurring artwork for: {show.title}')

    args = [
        'python', JBOPS_SCRIPT_PATH,
        '--rating_key', str(show.ratingKey)
    ]

    if mode == 'blur':
        args += ['--blur', BLUR_AMOUNT, '--upload']
    elif mode == 'remove':
        args += ['--remove', '--upload']

    subprocess.run(args)

