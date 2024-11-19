package main

import (
	"github.com/Maxxxxxx-x/iris-wave/internal/config"
	"github.com/Maxxxxxx-x/iris-wave/internal/logger"
)

const version = "dev"

func main() {
    cfg, err := config.GetConfig()

    log := logger.New(&cfg.Logging, cfg.Env)
	if err != nil {
        log.Error().Err(err).Msg("Error loading config. Using defaults.")
	}

    log.Info().Caller().Msg("Successfully loaded config!")
}
