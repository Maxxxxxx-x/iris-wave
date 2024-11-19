package config

import (
	"os"
	"path"

	"github.com/Maxxxxxx-x/iris-wave/internal/utils"
	"gopkg.in/yaml.v3"
)

type RESTConfig struct {
	Host string `yaml:"host"`
	Port string `yaml:"port"`
}

type DatabaseConfig struct {
	Host string `yaml:"host"`
	Port string `yaml:"port"`
}

type LoggingConfig struct {
	LogPath      string `yaml:"LogPath"`
	LogLevel     string `yaml:"LogLevel"`
	CompressLogs bool   `yaml:"CompressLogs"`
	MaxAge       int    `yaml:"MaxAge"`
	MaxSize      int    `yaml:"MaxSize"`
	MaxBackups   int    `yaml:"MaxBackups"`
}

type Config struct {
	Env      string
	REST     RESTConfig     `yaml:"REST"`
	Database DatabaseConfig `yaml:"Database"`
	Logging  LoggingConfig  `yaml:"Logging"`
}

func loadDefaultLoggingConfig() LoggingConfig {
	return LoggingConfig{
		LogPath:    "./logs/iris.log",
		LogLevel:   "DEBUG",
		MaxSize:    50,
		MaxBackups: 10,
	}
}

func loadDefaultRESTConfig() RESTConfig {
	return RESTConfig{
		Host: "127.0.0.1",
		Port: "12345",
	}
}

func loadDefaultDatabaseConfig() DatabaseConfig {
	return DatabaseConfig{
		Host: "iris-db",
		Port: "5432",
	}
}

func loadDefaultConfig() Config {
	return Config{
		Env:      "dev",
		REST:     loadDefaultRESTConfig(),
		Database: loadDefaultDatabaseConfig(),
		Logging:  loadDefaultLoggingConfig(),
	}
}

func GetConfig() (Config, error) {
	config := Config{}

	env, found := os.LookupEnv("APP_ENV")
	if !found {
		env = "dev"
	}

	config.Env = env

	configPath := "/config"
	if env == "dev" {
		execPath, err := os.Executable()
		if err != nil {
			return loadDefaultConfig(), err
		}
		configPath = path.Join(path.Dir(execPath), "../../config.yml")
	}

	if _, err := os.Stat(configPath); err != nil {
		return loadDefaultConfig(), err
	}

	configData, err := os.ReadFile(configPath)
	if err != nil {
		return loadDefaultConfig(), err
	}

	if err := yaml.Unmarshal(configData, &config); err != nil {
		return loadDefaultConfig(), err
	}

	if valid, err := utils.ValidatePort(config.REST.Port); !valid || err != nil {
		config.REST = loadDefaultRESTConfig()
		return config, err
	}

	if valid, err := utils.ValidatePort(config.Database.Port); !valid || err != nil {
		config.Database = loadDefaultDatabaseConfig()
		return config, err
	}

	return config, nil
}
