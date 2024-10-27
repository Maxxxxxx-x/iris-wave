package log

import (
	"fmt"
	"os"
	"strings"
	"time"

	"github.com/rs/zerolog"
)

func CreateLogger(serviceName string) zerolog.Logger {
    serviceName = strings.ToLower(fmt.Sprintf("iris-wave/%s", serviceName))
    zerolog.TimeFieldFormat = zerolog.TimeFormatUnix
    loggerOutput := zerolog.ConsoleWriter{
        Out: os.Stdout,
        TimeFormat: time.RFC3339,
    }

    loggerOutput.FormatLevel = func(i interface{}) string {
        return strings.ToUpper(fmt.Sprintf("[%s]", i))
    }

    loggerOutput.FormatFieldName = func(i interface{}) string {
        return ""
    }

    loggerOutput.FormatFieldValue = func(i interface{}) string {
        return fmt.Sprintf("[%s]", i)
    }

    return zerolog.New(loggerOutput).With().Timestamp().Str("service", serviceName).Logger()
}
