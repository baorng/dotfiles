function pwnbox
    set container_name pwnbox_persistent
    set image pigeon_pwn

    # Check if container exists (running or stopped)
    if docker ps -a --format '{{.Names}}' | grep -Eq "^$container_name\$"
        # If stopped, start it
        if not docker ps --format '{{.Names}}' | grep -Eq "^$container_name\$"
            docker start $container_name
        end
        # Attach to the running container
        docker exec -it $container_name /bin/bash
    else
        # Create and run for the first time
        docker run -it \
            --platform linux/amd64 \
            --cap-add=SYS_PTRACE \
            --security-opt seccomp=unconfined \
            -v (pwd):/pwn \
            --name $container_name \
            $image
    end
end
