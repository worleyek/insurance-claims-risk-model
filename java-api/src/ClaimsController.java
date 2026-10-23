package com.portfolio.claims;

import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ClaimsController {
  private final JdbcTemplate db;
  public ClaimsController(JdbcTemplate db) { this.db = db; }

  @GetMapping("/health")
  public Map<String, Object> health() {
    Integer result = db.queryForObject("SELECT 1", Integer.class);
    return Map.of("status", "UP", "database", result != null && result == 1 ? "UP" : "DOWN");
  }

  @GetMapping("/claims")
  public List<Map<String, Object>> list(@RequestParam(defaultValue="0") int page,
                                       @RequestParam(defaultValue="20") int size) {
    if (page < 0 || size < 1 || size > 100 || (long)page * size > Integer.MAX_VALUE)
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "page must be >= 0 and size 1..100");
    return db.queryForList("SELECT * FROM public.claims_final ORDER BY customer_id LIMIT ? OFFSET ?", size, page * size);
  }

  @GetMapping("/claims/{customerId}")
  public Map<String, Object> one(@PathVariable String customerId) {
    List<Map<String, Object>> rows = db.queryForList("SELECT * FROM public.claims_final WHERE customer_id = ?", customerId);
    if (rows.isEmpty()) throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Customer not found");
    return rows.get(0);
  }

  @GetMapping("/analytics/summary")
  public Map<String, Object> summary() {
    return db.queryForMap("""
      SELECT COUNT(*) AS customer_count,
             ROUND(AVG(total_claim_amount)::numeric, 2) AS average_claim_amount,
             ROUND(SUM(total_claim_amount)::numeric, 2) AS total_claim_amount,
             ROUND(AVG(monthly_premium_auto)::numeric, 2) AS average_monthly_premium
      FROM public.claims_final
      """);
  }

  @GetMapping("/analytics/by-state")
  public List<Map<String, Object>> byState() {
    return db.queryForList("""
      SELECT state, COUNT(*) AS customer_count,
             ROUND(AVG(total_claim_amount)::numeric, 2) AS average_claim_amount,
             ROUND(SUM(total_claim_amount)::numeric, 2) AS total_claim_amount
      FROM public.claims_final GROUP BY state ORDER BY customer_count DESC, state
      """);
  }

  @GetMapping("/analytics/risk-distribution")
  public List<Map<String, Object>> riskDistribution() {
    return db.queryForList("""
      SELECT risk_score, COUNT(*) AS customer_count,
             ROUND(AVG(total_claim_amount)::numeric, 2) AS average_claim_amount
      FROM public.claims_final GROUP BY risk_score ORDER BY risk_score
      """);
  }

  @GetMapping("/analytics/severity")
  public List<Map<String, Object>> severity() {
    return db.queryForList("""
      SELECT claim_severity, COUNT(*) AS customer_count,
             ROUND(AVG(total_claim_amount)::numeric, 2) AS average_claim_amount
      FROM public.claims_final GROUP BY claim_severity ORDER BY customer_count DESC
      """);
  }
}
