package utils

import (
	"fmt"
	"strconv"
)

func ValidatePort(port string) (bool, error) {
	portNum, err := strconv.Atoi(port)
	if err != nil {
		return false, err
	}

	// port range 1 - 65535
	if portNum < 1 || portNum > 65535 {
		return false, fmt.Errorf("Port %s is out of range!\n", port)
	}

	// privileged port = 1 - 1024
	if portNum < 1024 {
		return false, fmt.Errorf("Port %s is a privileged port!\n", port)
	}

	return true, nil
}
