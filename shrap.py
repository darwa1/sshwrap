#!/usr/bin/env python3

import argparse
import subprocess
import shlex


def build_ssh_command(args):
    control_socket = f"/tmp/ssh_{args.target}"

    ssh_cmd = [
        "ssh",
        "-C",
        "-o", "ControlMaster=auto",
        "-o", f"ControlPath={control_socket}",
        "-o", "ServerAliveInterval=79",
        "-o", "StrictHostKeyChecking=no",
        "-o", "UserKnownHostsFile=/dev/null",
    ]

    if args.identity:
        ssh_cmd += ["-i", args.identity]

    if args.listen_port and args.tport:
        ssh_cmd += [
            "-L",
            f"{args.listen_port}:{args.target}:{args.tport}"
        ]

    if args.redirector:
        ssh_cmd += ["-J", f"{args.user}@{args.redirector}"]

    destination = f"{args.user}@{args.target}"
    ssh_cmd.append(destination)

    ssh_cmd.append("/bin/sh")

    return ssh_cmd


def main():
    parser = argparse.ArgumentParser(
        description="Python SSH wrapper with persistent multiplexed control socket"
    )

    parser.add_argument("-u", "--user", required=True, help="SSH user")
    parser.add_argument("-P", "--password", help="SSH password (uses sshpass)")
    parser.add_argument("-i", "--identity", help="Identity (private key) file")

    parser.add_argument("-r", "--redirector", help="Redirector / jump host IP")
    parser.add_argument("-t", "--target", required=True, help="Target IP")

    parser.add_argument("--tport", type=int, help="Target port")
    parser.add_argument("-l", "--listen-port", type=int, help="Local listening port")

    args = parser.parse_args()

    ssh_cmd = build_ssh_command(args)

    if args.password:
        ssh_cmd = ["sshpass", "-p", args.password] + ssh_cmd

    print("[*] Executing SSH command:")
    print(" ".join(shlex.quote(x) for x in ssh_cmd))

    subprocess.run(ssh_cmd)


if __name__ == "__main__":
    main()
