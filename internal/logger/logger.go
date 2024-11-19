package logger

import (
	"io"
	"os"
	"time"

	"github.com/Maxxxxxx-x/iris-wave/internal/config"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/pkgerrors"
	"gopkg.in/natefinch/lumberjack.v2"
)

type Logger interface {
	Log() *zerolog.Event
	Fatal() *zerolog.Event
	Err(err error) *zerolog.Event
	Error() *zerolog.Event
	Warn() *zerolog.Event
	Info() *zerolog.Event
	Trace() *zerolog.Event
	Debug() *zerolog.Event
	With() zerolog.Context
	SetLogLevel(level string)
	Printf(format string, v ...interface{})
	Print(v ...interface{})
}

type DefaultLogger struct {
	log     zerolog.Logger
	level   zerolog.Level
	writers []io.Writer
}

func (logger *DefaultLogger) SetLogLevel(level string) {
	lvl, err := zerolog.ParseLevel(level)
	if err != nil {
		lvl = zerolog.DebugLevel
	}
	zerolog.SetGlobalLevel(lvl)
}

func (logger *DefaultLogger) Log() *zerolog.Event {
	return logger.log.Log().Timestamp()
}

func (logger *DefaultLogger) Fatal() *zerolog.Event {
	return logger.log.Fatal().Timestamp()
}

func (logger *DefaultLogger) Error() *zerolog.Event {
	return logger.log.Error().Timestamp()
}

func (logger *DefaultLogger) Err(err error) *zerolog.Event {
	return logger.log.Err(err).Timestamp()
}

func (logger *DefaultLogger) Warn() *zerolog.Event {
	return logger.log.Warn().Timestamp()
}

func (logger *DefaultLogger) Info() *zerolog.Event {
	return logger.log.Info().Timestamp()
}

func (logger *DefaultLogger) Debug() *zerolog.Event {
	return logger.log.Debug().Timestamp()
}

func (logger *DefaultLogger) Trace() *zerolog.Event {
	return logger.log.Trace().Timestamp()
}

func (logger *DefaultLogger) Print(v ...interface{}) {
	logger.log.Print(v...)
}

func (logger *DefaultLogger) Printf(format string, v ...interface{}) {
	logger.log.Printf(format, v...)
}

func (logger *DefaultLogger) With() zerolog.Context {
	return logger.log.With().Timestamp()
}

func New(cfg *config.LoggingConfig, env string) Logger {
	logger := &DefaultLogger{
		level:   zerolog.DebugLevel,
		writers: make([]io.Writer, 0),
	}

	logger.SetLogLevel(cfg.LogLevel)

	if env == "dev" {
		consoleWriter := zerolog.ConsoleWriter{
			Out:        os.Stderr,
			TimeFormat: time.RFC3339,
		}

		logger.writers = append(logger.writers, consoleWriter)
	} else {
		logger.writers = append(logger.writers, os.Stderr)
	}

	if cfg.LogPath != "" {
		logger.writers = append(logger.writers, &lumberjack.Logger{
			Filename:   cfg.LogPath,
			MaxSize:    cfg.MaxSize,
			MaxBackups: cfg.MaxBackups,
		})
	}

	zerolog.TimeFieldFormat = time.RFC3339
	zerolog.ErrorStackMarshaler = pkgerrors.MarshalStack

	logger.log = zerolog.New(io.MultiWriter(logger.writers...)).With().Stack().Logger()

	return logger
}
