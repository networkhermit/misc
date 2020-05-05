package main

import (
    "encoding/json"
    "fmt"
    "io/ioutil"
    "log"
    "net/http"
)

type config struct {
    SCHEME string `json:"scheme"`
    TOKEN string `json:"token"`
}

type object struct {
    OK bool `json:"ok"`
}

func main() {
    file, err := ioutil.ReadFile("../.privacy/slack.json")
    if err != nil {
        log.Fatal(err)
    }

    auth := config{}
    err = json.Unmarshal(file, &auth)
    if err != nil {
        log.Fatal(err)
    }

    url := "https://slack.com/api/auth.test"

    clent := http.Client{}

    req, err := http.NewRequest(http.MethodGet, url, nil)
    if err != nil {
        log.Fatal(err)
    }

    req.Header.Set("User-Agent", "Krypton")
    req.Header.Set("Authorization", fmt.Sprintf("%s %s", auth.SCHEME, auth.TOKEN))

    res, err := clent.Do(req)
    if err != nil {
        log.Fatal(err)
    }
    defer res.Body.Close()

    if res.StatusCode != 200 {
        log.Fatal(res.Status)
    }

    body, err := ioutil.ReadAll(res.Body)
    if err != nil {
        log.Fatal(err)
    }

    obj := object{}
    err = json.Unmarshal(body, &obj)
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println(obj.OK)
}
