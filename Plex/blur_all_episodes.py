import subprocess
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

# Connect to Plex
plex = PlexServer(PLEX_URL, PLEX_TOKEN)
library = plex.library.section(LIBRARY_NAME)

# Get the show
shows = library.all()
print(f'Found {len(shows)} shows in "{LIBRARY_NAME}".')

for show in shows:
    # Call the JBOPS script with blur parameter
    print(f'Blurring artwork for: {show.title}')
    subprocess.run([
        'python', JBOPS_SCRIPT_PATH,
        '--rating_key', str(show.ratingKey),
        '--blur', '25',
        '--upload'
    ])

