# Test Cases

## 1. Create: full payload

```bash
curl -X POST $BASE/readings \
  -H 'Content-Type: application/json' \
  -d '{"device_id": "sensor-01", "temperature": 22.5, "humidity": 61}'
```

## 2. Create: partial payload

```bash
curl -X POST $BASE/readings \
  -H 'Content-Type: application/json' \
  -d '{"device_id": "sensor-02", "temperature": 19.1}'
```

## 3. Create: zero value

```bash
curl -X POST $BASE/readings \
  -H 'Content-Type: application/json' \
  -d '{"device_id": "sensor-01", "temperature": 0, "humidity": 0}'
```

## 4. Create: missing device_id

```bash
curl -X POST $BASE/readings \
  -H 'Content-Type: application/json' \
  -d '{"temperature": 22.5}'
```
## 5. List

```bash
curl "$BASE/readings?device_id=sensor-01"
```
## 6. List: unknown device

```bash
curl "$BASE/readings?device_id=does-not-exist"
```

Expect `200` and `[]`.

## 7. Get one

```bash
curl "$BASE/readings/<recorded_at>?device_id=sensor-01"
```
## 8. Get one: missing

```bash
curl "$BASE/readings/1999-01-01T00:00:00?device_id=sensor-01"
```

Expect `404`.

## 9. Update: both fields

```bash
curl -X PUT "$BASE/readings/<recorded_at>?device_id=sensor-01" \
  -H 'Content-Type: application/json' \
  -d '{"temperature": 25.0, "humidity": 55}'
```

## 10. Update: one field

```bash
curl -X PUT "$BASE/readings/<recorded_at>?device_id=sensor-01" \
  -H 'Content-Type: application/json' \
  -d '{"temperature": 30.0}'
```

## 11. Update: no updatable fields

```bash
curl -X PUT "$BASE/readings/<recorded_at>?device_id=sensor-01" \
  -H 'Content-Type: application/json' \
  -d '{}'
```

## 12. Delete

```bash
curl -X DELETE "$BASE/readings/<recorded_at>?device_id=sensor-01"
```


## 13. Delete: nonexistent key

```bash
curl -X DELETE "$BASE/readings/1999-01-01T00:00:00?device_id=sensor-01"
```

## Not covered

- Load and concurrency testing
- Malformed JSON bodies
- Pagination beyond DynamoDB's 1MB Query limit
- Authentication: the API is currently public and unauthenticated
- Very large numeric values and Decimal precision limits