import http from "k6/http";
import { check, sleep } from "k6";

// Parameters for registration/login
const USERNAME = "testuser";
const PASSWORD = "testuser";

// Load test options
export let options = {
  vus: 10000, // Количество виртуальных пользователей
  duration: "10s", // Длительность теста
  thresholds: {
    http_req_duration: ["p(95)<500"], // 95% запросов должны выполняться быстрее 500ms
  },
  ext: {
    loadimpact: {
      distribution: {
        "amazon:fr:paris": { loadZone: "amazon:fr:paris", percent: 50 },
      },
    },
  },
};

// URL for login
const LOGIN_URL = "http://127.0.0.1:8000/login";

export function setup() {
  let loginRes = http.post(
    LOGIN_URL,
    JSON.stringify({
      login: USERNAME,
      password: PASSWORD,
    }),
    {
      headers: { "Content-Type": "application/json" },
    }
  );

  // Check if login was successful
  let loginSuccess = check(loginRes, {
    "login successful": (r) =>
      r.status === 200 && r.json() && r.json("access_token"),
  });

  if (!loginSuccess) {
    console.error(
      `Login failed: status ${loginRes.status}, body: ${loginRes.body}`
    );
    throw new Error("Login failed, cannot continue test");
  }

  // Return the token to be used in the default function
  return {
    token: loginRes.json("access_token"),
  };
}

export default function (data) {
  // Access the token passed from the setup function
  const TOKEN = data.token;

  const headers = {
    auth: TOKEN, // Pass the token in headers
  };

  const city = city_generate();
  const dateTime = DateTime_generate();

  try {
    let res = http.get(
      `http://127.0.0.1:8000/forecast/today?city=${city}&time=${dateTime}`,
      { headers: headers }
    );

    let forecastSuccess = check(res, {
      "forecast request successful": (r) => r.status === 200 && r.body,
    });

    if (!forecastSuccess) {
      console.error(
        `Forecast request failed: status ${res.status}, body: ${res.body}`
      );
    } else {
      console.log(`Successful forecast: city ${city}, time ${dateTime}`);
    }
  } catch (err) {
    console.error(`Request error: ${err.message}`);
  }

  sleep(0.3);
}

// Helper functions
function city_generate() {
  return Math.floor(Math.random() * 30 + 1);
}

function DateTime_generate() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate() - 7).padStart(2, "0");
  const hours = String(now.getHours()).padStart(2, "0");
  const minutes = String(now.getMinutes()).padStart(2, "0");

  return `${year}-${month}-${day}%20${hours}:${minutes}`;
}
