---
title: "E2E testing Spring Boot applications"
description: "Instructions for end-to-end testing in Spring Boot, covering everything from project structure to stable test flows and CI integration."
pubDate: "2025-10-19"
---

## Project structure

```
src
├── main
│   ├── frontend
│   │   ├── package.json
│   │   ├── package-lock.json
│   │   └── styles.css
│   ├── java
│   │   └── com
│   │       └── thilohohlt
│   │           ├── Main.java
│   │           └── service
│   │               └── ExampleService.java
│   └── resources
│       ├── application.properties
│       ├── static
│       │   └── main.css
│       └── templates
│           └── example-page.html
└── test
    └── java
        └── com
            └── thilohohlt
                └── test
                    └── e2e
                        ├── BaseTest.java
                        ├── ExampleTest.java
                        ├── mocks
                        │   └── ExampleServiceMock.java
                        ├── pages
                        │   └── ExamplePage.java
                        └── utils
                            └── TestData.java
```

## Maven dependencies

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>com.microsoft.playwright</groupId>
    <artifactId>playwright</artifactId>
    <version>1.55.0</version>
    <scope>test</scope>
</dependency>
```

## TestData

```java
package com.thilohohlt.test.e2e.utils;

public class TestData {
    public static final String USER = "ExampleUser";
}
```

## ExampleServiceMock

```java
package com.thilohohlt.test.e2e.mocks;

import com.thilohohlt.service.ExampleService;
import com.thilohohlt.test.e2e.utils.TestData;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ExampleServiceMock extends ExampleService {
    @Override
    public String getData(String user) {
        return TestData.USER;
    }
}
```

## BaseTest

```java
package com.thilohohlt.test.e2e;

import com.microsoft.playwright.*;
import org.junit.jupiter.api.*;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestPropertySource(properties = {
        "spring.profiles.active=test",
        "logging.level.com.thilohohlt=DEBUG"
})
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public abstract class BaseTest {

    @LocalServerPort
    protected int port;

    protected static Playwright playwright;
    protected static Browser browser;
    protected BrowserContext browserContext;
    protected Page page;

    protected String baseUrl;

    @BeforeAll
    public static void launchBrowser() {
        playwright = Playwright.create();

        BrowserType.LaunchOptions launchOptions = new BrowserType.LaunchOptions()
                .setHeadless(isHeadless());

        String browserName = System.getProperty("browser", "chromium").toLowerCase();
        switch (browserName) {
            case "firefox":
                browser = playwright.firefox().launch(launchOptions);
                break;
            case "webkit":
                browser = playwright.webkit().launch(launchOptions);
                break;
            case "chromium":
            default:
                browser = playwright.chromium().launch(launchOptions);
                break;
        }
    }

    @BeforeEach
    public void createContextAndPage() {
        baseUrl = "http://localhost:" + port;

        Browser.NewContextOptions contextOptions = new Browser.NewContextOptions()
                .setViewportSize(1280, 720)
                .setIgnoreHTTPSErrors(true)
                .setLocale("en-US")
                .setTimezoneId("America/New_York");

        contextOptions.setExtraHTTPHeaders(java.util.Map.of(
                "Accept-Language", "en-US,en;q=0.9"
        ));

        browserContext = browser.newContext(contextOptions);

        if (isDebugMode()) {
            browserContext.onRequest(request ->
                    System.out.println(">> " + request.method() + " " + request.url())
            );
            browserContext.onResponse(response ->
                    System.out.println("<< " + response.status() + " " + response.url())
            );
        }

        page = browserContext.newPage();

        page.setDefaultTimeout(getDefaultTimeout());
        page.setDefaultNavigationTimeout(getNavigationTimeout());
    }

    @AfterEach
    public void closeContext() {
        if (browserContext != null) {
            browserContext.close();
        }
    }

    @AfterAll
    public static void closeBrowser() {
        if (browser != null) {
            browser.close();
        }
        if (playwright != null) {
            playwright.close();
        }
    }

    protected static boolean isHeadless() {
        return Boolean.parseBoolean(System.getProperty("headless", "true"));
    }

    protected static boolean isDebugMode() {
        return Boolean.parseBoolean(System.getProperty("debug", "false"));
    }

    protected static int getDefaultTimeout() {
        return Integer.parseInt(System.getProperty("timeout", "30000"));
    }

    protected static int getNavigationTimeout() {
        return Integer.parseInt(System.getProperty("navigationTimeout", "30000"));
    }
}
```

## ExamplePage

```java
package com.thilohohlt.test.e2e.pages;

import com.microsoft.playwright.Page;

public record ExamplePage(Page page, String baseUrl) {
    public void navigate() {
        page.navigate(baseUrl);
    }
}
```

## ExampleTest

```java
package com.thilohohlt.test.e2e;

import com.thilohohlt.test.e2e.pages.ExamplePage;
import org.junit.jupiter.api.*;
import static org.assertj.core.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@DisplayName("Example E2E Test")
public class ExampleTest extends BaseTest {
    private ExamplePage examplePage;

    @BeforeEach
    public void setupPages() {
        examplePage = new ExamplePage(page, baseUrl);
    }

    @Test
    @Order(1)
    @DisplayName("Should navigate to example page")
    public void testNavigationToPlayerPage() {
        examplePage.navigate();
    }
}
```
