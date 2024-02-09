# B-Tocs ABAP Plugin LibreTranslate
![Bride To Other Cool Stuff](res/btocs_logo.gif)

## Summary

This plugin is based on the [B-Tocs ABAP SDK](https://github.com/b-tocs/abap_btocs_core) and enables the SAP ABAP Server to use the translation service [LibreTranslate](https://libretranslate.com/).

The plugin is free at your own risk. 
MIT License.


## Architecture

```mermaid
flowchart LR
    subgraph sap["SAP ABAP System"]
        sap_bf["SAP Business Functions"]
        subgraph sdk["B-Tocs SDK"]
            sdkcore["B-Tocs SDK"]
            plugin["Plugin LibreTranslate"]
            sdkcore-->plugin
        end
        sap_bf-->sdkcore
    end

    subgraph cloud-native-world["Cloud Native World"]
        subgraph onpremise["Data Center On-Prem"]
            service1
        end
        subgraph datacenter["Data Center"]
            service2
        end
        subgraph hyperscaler["HyperScaler"]
            service3
        end
        subgraph sapbtp["SAP BTP"]
            service4
        end
        subgraph saas["SaaS"]
            service5
        end
    end

    plugin-->service1    
    plugin-->service2    
    plugin-->service3    
    plugin-->service4    
    plugin-->service5    

```

## Installation & Configuration

1. The installed [B-Tocs ABAP SDK](https://github.com/b-tocs/abap_btocs_core) is required. 
2. Install the plugin it with [abapGit](https://abapgit.org).
3. Use Package ZBTOCS_LIBTRL or $BTOCS_LIBTRL (local only)
4. Configure SM59 RFC Destination to your remote service
5. Test connection
6. Execute program ZBTOCS_LIBTRL_GUI_RWS_DEMO for a demo
7. Use it in own scenarios

## Know issues
(no issues knwon)

