import http from "k6/http";
import { check, sleep } from "k6";

// Параметры для регистрации/логина
const USERNAME = "testuser";
const PASSWORD = "testuser";

// URL для регистрации и логина
const LOGIN_URL = "http://localhost:8000/login";

export default function () {
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

  // Проверка, что логин прошёл успешно (например, получили статус 200 и токен)
  check(loginRes, {
    "login successful": (r) => r.status === 200 && r.json("access_token"),
  });

  // Извлекаем токен из ответа
  const token = loginRes.json("access_token");

  // 2. Теперь делаем запрос с использованием токена
  const headers = {
    auth: token, // Передаем токен в заголовках
  };

  // http.get(http.url`https://test.k6.io?id=${id}`);

  // я гл
  // 3. Запрашиваем защищённый ресурс с токеном
  let res = http.get(
    `http://localhost:8000/forecast/today?city=${city_generate()}&time=${DateTime_generate()}`,
    {
      headers: headers, // Передаем заголовки с токеном

      // Передаем параметры запроса
    }
  );

  check(res, { "forecast request successful": (r) => r.status === 200 });

  sleep(0.3);
}

function city_generate() {
  return Math.floor(Math.random() * 30 + 1); // Генерируем случайное число от 0 до 30
}

function DateTime_generate() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0"); // Месяцы начинаются с 0, добавляем 1
  const day = String(now.getDate()).padStart(2, "0");
  const hours = String(now.getHours()).padStart(2, "0");
  const minutes = String(now.getMinutes()).padStart(2, "0");

  return `${year}-${month}-${day}%20${hours}:${minutes}`;
}
