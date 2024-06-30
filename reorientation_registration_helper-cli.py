# CLI interface to launch pathmatcher directly, mostly useful to build a pyInstaller binary
from pathmatcher.reorientation_registration_helper import main as reorientation_registration_helper
if __name__ == '__main__':
    reorientation_registration_helper()
