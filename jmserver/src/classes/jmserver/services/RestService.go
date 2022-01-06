package services
import (
	"fmt"
	"../../sr"
	"net/http"
	"strconv"
)

type RestService struct {
    servicePort    int
    serviceName    string
}
var rs *RestService;
func GetRestServiceInstance() *RestService {
    if rs == nil {
        rs = &RestService{}
        var cs = GetConfigurationServiceInstance();
        rs.servicePort = 4445;
        rs.servicePort, _ = strconv.Atoi(cs.GetProperty("apiPort", "4445").(string));
        rs.serviceName = "Job Manager REST Service";
    }
    return rs;
}

func (x *RestService) GetVersion(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte(fmt.Sprintf("{\"version\":\"%s\"}", sr.APPLICATION_VERSION)));
}

func (x *RestService) Initialize() {
    // Call Initialize on all remote services to start the endpoints
	GetRestCompanyServiceInstance().Initialize();
	GetRestResultsServiceInstance().Initialize();

    //Configure common endpoints
    http.HandleFunc("/api/version/", x.GetVersion);

    // Start listener
    http.ListenAndServe(fmt.Sprintf(":%d", x.servicePort), nil);
}
