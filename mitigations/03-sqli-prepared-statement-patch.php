<?php
/**
 * ==============================================================================
 * ApexPlanet Cybersecurity Internship - Task 5 Remediation
 * Patch: 03-sqli-prepared-statement-patch.php
 * Target: /var/www/html/DVWA/vulnerabilities/sqli/source/high.php
 * Purpose: Secure SQL execution using PDO prepared statements
 * ==============================================================================
 */

if (isset($_SESSION['id'])) {
    // Extract sanitized session parameter
    $id = $_SESSION['id'];

    // Enforce integer validation
    if (!is_numeric($id)) {
        echo "<pre>User ID must be numeric.</pre>";
        exit;
    }

    try {
        // Secure PDO connection
        $db = new PDO('mysql:host=127.0.0.1;dbname=dvwa;charset=utf8mb4', 'dvwa', 'password');
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);

        // Parameterized query eliminates syntax alteration
        $stmt = $db->prepare('SELECT first_name, last_name FROM users WHERE user_id = :id LIMIT 1;');
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();

        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if ($rows) {
            foreach ($rows as $row) {
                echo "<pre>ID: {$id}<br />First name: " . htmlspecialchars($row['first_name'], ENT_QUOTES, 'UTF-8') . "<br />Surname: " . htmlspecialchars($row['last_name'], ENT_QUOTES, 'UTF-8') . "</pre>";
            }
        } else {
            echo "<pre>User ID not found.</pre>";
        }
    } catch (PDOException $e) {
        // Suppress detailed database error from client output
        error_log("Database error in SQLi module: " . $e->getMessage());
        echo "<pre>An internal database error occurred.</pre>";
    }
}
?>
