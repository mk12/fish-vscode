# Copyright 2022 Mitchell Kember. Subject to the MIT License.

function code --description "Open in VS Code"
    if test (count $argv) != 1 || string match -q -- "-*" "$argv[1]"
        command code $argv
        return
    end
    switch (uname -s)
        case Darwin
            # This is faster and avoids a Dock animation:
            # https://github.com/microsoft/vscode/issues/60579
            test -e $argv[1]; or touch $argv[1]
            open -b com.microsoft.VSCode $argv[1]
        case Linux
            if test -d ~/.vscode-server -a -z "$VSCODE_IPC_HOOK_CLI"
                for s in ~/.vscode-server/bin/*/server.sh
                    if pgrep -f $s &> /dev/null
                        set bins $bins (dirname $s)
                    end
                end
                if test (count $bins) = 0
                    echo "Error: no VS Code remote server found" >&2
                    return
                end
                if test (count $bins) -gt 1
                    echo "Error: more than one VS Code remote server found" >&2
                    return
                end
                set code "$bins/bin/remote-cli/code"
                if not command -qv socat
                    echo "Error: please install socat" >&2
                    return
                end
                for f in /run/user/(id -u)/vscode-ipc-*.sock
                    if socat -u OPEN:/dev/null UNIX-CONNECT:$f &> /dev/null
                        set socks $socks $f
                    else
                        rm $f
                    end
                end
                if test (count $socks) = 0
                    echo "Error: no VS Code remote server socket found" >&2
                    return
                end
                if test (count $socks) -gt 1
                    echo "Error: more than one VS Code remote server socket found" >&2
                    return
                end
                VSCODE_IPC_HOOK_CLI=$socks $code $argv
            else
                command code $argv
            end
    end
end
