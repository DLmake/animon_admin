# Shared Multipass steps, used by windows.sh, mac.sh and linux.sh.
# Not meant to be run directly - the OS scripts "source" it.

NAME=animon
has() { command -v "$1" >/dev/null 2>&1; }

# start_vm <path of the project folder in the form Multipass expects>
start_vm() {
  local here="$1"

  if ! multipass info "$NAME" >/dev/null 2>&1; then
    echo "==> Creating VM '$NAME'..."
    multipass launch 22.04 --name "$NAME" --cpus 2 --memory 2G --disk 10G --cloud-init cloud-init.yaml
    echo "==> Sharing $here as /vagrant..."
    multipass mount "$here" "$NAME:/vagrant"
  else
    echo "==> VM '$NAME' already exists, starting it..."
    multipass start "$NAME"
  fi

  echo "==> Waiting for first-boot setup (installing Ansible)..."
  multipass exec "$NAME" -- cloud-init status --wait

  echo "==> Running playbook..."
  multipass exec "$NAME" -- sudo ansible-playbook -i localhost, -c local /vagrant/playbook.yml

  local ip
  ip="$(multipass info "$NAME" | awk '/IPv4/ {print $2; exit}')"
  echo
  echo "==> Done! Open http://$ip in your browser."
}
