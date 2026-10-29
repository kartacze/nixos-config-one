# SSH public keys (copied from antaba's lib/keys.nix).
{
  # The original admin key, present since the first install.
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVcFY/yyrBFoEHfJswHYqI/A52Sw+Zg43HzA+I5+Rts";
  dell = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5X3sPc15vP/7Us0WVa/3+amgFyfueQZjhQ3KWal3aJ";

  # Passphrase-less key used by the root-owned sshfs automount on x1.
  x1-sshfs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0D16wpF01NOThYmx5nDgiPNvH3ML6/q8Bfa8rteqQJ";
}
