package services
import (
	"../../common"
	"../../sr"
	"io/ioutil"
)

// Service interface
type IService interface {
	Initialize()
}
/*****************************************************************************/

// Default service
type EmptyService struct{
	instance *EmptyService
}
func (x *EmptyService) Initialize() { }
/*****************************************************************************/

// ServiceProvider interface
type IServiceProvider interface {
	RegisterService (a string, b IService);
	GetService (a string) IService;
	ContainsService (a string) bool
	Services() map[string]IService;
}
/*****************************************************************************/

// Default service provider
type EmptyServiceProvider struct {
	instance *EmptyServiceProvider;
	services map[string]IService;
}
func (x *EmptyServiceProvider) RegisterService (a string, b IService) {}
func (x *EmptyServiceProvider) GetService (a string) IService { return nil; }
func (x *EmptyServiceProvider) ContainsService(a string) bool { return true; }
func (x *EmptyServiceProvider) Services() map[string]IService { return x.services; }
/*****************************************************************************/

// ConfigurationService
type ConfigurationService struct {}
var csi *ConfigurationService;
func GetConfigurationServiceInstance() *ConfigurationService {
	if csi == nil {
		csi = &ConfigurationService{};
	}
	return csi;
}
func (x *ConfigurationService) GetProperty(a string, b interface{}) interface{} {
	rawXml, _ := ioutil.ReadFile((sr.GetSRInstance()).GetConfigurationFile());
	var dict = common.StrToDictionary(rawXml);
	if dict[a] == nil {
		return b;
	}
	return dict[a];
}
func (x *ConfigurationService) SaveConfiguration(a string) {
	ioutil.WriteFile((sr.GetSRInstance()).GetConfigurationFile(), []byte(a), 'w');
}
func (x *ConfigurationService) GetKey(a string, b interface{}) interface{} { return x.GetProperty(a, b); }
/*****************************************************************************/

// Service helpers
/*****************************************************************************/

// Template
// Interface
/*****************************************************************************/

// Local service
/*****************************************************************************/

// Rest service
/*****************************************************************************/

