<?php
// Include database connection
require_once 'db.php';
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
error_log("Raw POST data: " . file_get_contents('php://input'));

// Automatically mark users offline if inactive for 30 seconds
$autoOfflineStmt = $db->prepare("UPDATE users SET is_online = FALSE WHERE is_online = TRUE AND last_seen < (NOW() - INTERVAL 30 SECOND)");
$autoOfflineStmt->execute();

// Start session if not already started
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
// Set the Content-Type header to JSON
header('Content-Type: application/json');

// Function to check if the user is authenticated

// Handle incoming POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'] ?? json_decode(file_get_contents('php://input'), true)['action'];

    switch ($action) {
        case 'signup':
            handleSignup($db);
            break;
        case 'login':
            handleLogin($db);
            break;
            case 'logout':
        $user_id = $_POST['user_id'];
        handleLogout($db, $user_id);
        break;
case 'update_online':
    header('Content-Type: application/json');

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['user_id'])) {
        echo json_encode(['success' => false, 'message' => 'User ID is required']);
        exit;
    }

    $user_id = $data['user_id'];

    // ✅ Use BOOLEAN (TRUE for online)
    $stmt = $db->prepare("UPDATE users SET is_online = TRUE, last_seen = NOW() WHERE id = ?");
    if ($stmt->execute([$user_id])) {
        echo json_encode(['success' => true, 'message' => 'User is online']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Database update failed']);
    }
    exit;

    case 'set_offline':
    header('Content-Type: application/json');

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['user_id'])) {
        echo json_encode(['success' => false, 'message' => 'User ID is required']);
        exit;
    }

    $user_id = $data['user_id'];

    // ✅ Use BOOLEAN (FALSE for offline)
    $stmt = $db->prepare("UPDATE users SET is_online = FALSE, last_seen = NOW() WHERE id = ?");
    if ($stmt->execute([$user_id])) {
        echo json_encode(['success' => true, 'message' => 'User set to offline']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Database update failed']);
    }
    exit;

    case 'get_status':
        $user_id = $_POST['user_id'];
        fetchUserStatus($db, $user_id);
        break;
        case 'search':
            handleSearch($db);
            break;
        case 'send_message':
            handleSendMessage($db);
            break;
        case 'fetch_messages':
            handleFetchMessages($db);
            break;
        case 'fetch_notifications':
            handleFetchNotifications($db);
            break;
        case 'mark_notifications_read':
            handleMarkNotificationsRead($db);
            break;
       case 'typing_status': // Added case for typing status
            handleTypingStatus($db);
            break;
        case 'get_typing_status': // Added case for fetching typing status
            handleGetTypingStatus($db);
            break;
    case 'create_group':
        createGroup($db);
        break;

    case 'fetch_public_groups':
    fetchPublicGroups($db); // Pass database connection
    break;
case 'fetch_user_groups':
    fetchUserGroups($db);
    break;
case 'join_group':
    handleJoinGroup($db);
    break;
case 'fetch_joined_groups':
    fetchJoinedGroups($db);
    break;
case 'send_group_message':
    handleSendGroupMessage($db);
    break;

case 'fetch_group_messages':
    handleFetchGroupMessages($db);
    break;
case 'fetch_group_users':
    fetchGroupUsers($db);
    break;
case 'remove_user':
    $data = json_decode(file_get_contents('php://input'), true); // Decode raw JSON input
    $group_id = $data['group_id'] ?? null;
    $user_id = $data['user_id'] ?? null;

    handleRemoveUser($db, $group_id, $user_id);
    break;
case 'block_user':
        handleBlockUser($db);
        break;
case 'unblock_user':
    handleUnblockUser($db);
    break;
case 'fetch_blocked_users':
        fetchBlockedUsers($db);
        break;
case 'leave_group':
    handleLeaveGroup($db, $_POST['group_id'], $_POST['user_id']);
    break;
case 'delete_group':
    handleDeleteGroup($db);
    break;
case 'edit_message':
        handleEditMessage($db);
        break;
    
    case 'delete_message':
        handleDeleteMessage($db);
        break;
    case 'edit_group_message':
        handleEditGroupMessage($db);
        break;
    
    case 'delete_group_message':
        handleDeleteGroupMessage($db);
        break;
   case 'like_group':
        handleLikeGroup($db);
        break;
        default:
            echo json_encode(['success' => false, 'message' => 'Invalid action']);
    }
}

// Handle user signup
function handleSignup($db) {
    $username = $_POST['username'];
    $password = password_hash($_POST['password'], PASSWORD_BCRYPT); // Encrypt password
    $profileIcon = $_FILES['profile_icon']['name'];

    $targetDir = "uploads/";
    $targetFile = $targetDir . basename($profileIcon);

    if (!move_uploaded_file($_FILES['profile_icon']['tmp_name'], $targetFile)) {
        echo json_encode(['success' => false, 'message' => 'Failed to upload profile icon']);
        return;
    }

    try {
        $stmt = $db->prepare("INSERT INTO users (username, password, profile_icon, last_active) VALUES (?, ?, ?, NOW())");
        $stmt->execute([$username, $password, $targetFile]);
        echo json_encode(['success' => true, 'message' => 'Signup successful']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Username already exists']);
    }
}

// Handle user login
// Function to update user status when logging in
// Function to handle user login and update online status
function handleLogin($db) {
    header('Content-Type: application/json'); // Ensure JSON response

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['username']) || !isset($data['password'])) {
        echo json_encode(['success' => false, 'message' => 'Username and password are required']);
        exit;
    }

    $username = trim($data['username']);
    $password = $data['password'];

    try {
        $stmt = $db->prepare("SELECT * FROM users WHERE username = ?");
        $stmt->execute([$username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($password, $user['password'])) {
            // Update online status and last seen
            $updateStmt = $db->prepare("UPDATE users SET is_online = 1, last_seen = NOW() WHERE id = ?");
            $updateStmt->execute([$user['id']]);

            echo json_encode([
                'success' => true, 
                'user_id' => $user['id'], 
                'username' => $user['username'], 
                'profile_icon' => $user['profile_icon']
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid username or password']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
    exit;
}

// Function to update user status when logging out
function handleLogout($db, $user_id) {
    header('Content-Type: application/json'); // Ensure JSON response

    if (!$user_id) {
        echo json_encode(['success' => false, 'message' => 'User ID is required']);
        exit;
    }

    $stmt = $db->prepare("UPDATE users SET is_online = 0, last_seen = NOW() WHERE id = ?");
    if ($stmt->execute([$user_id])) {
        echo json_encode(['success' => true, 'message' => 'Logged out successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to log out']);
    }
    exit;
}

// Function to fetch online status & last seen
function fetchUserStatus($db) {
    header('Content-Type: application/json'); // Ensure JSON output
    ob_clean(); // Remove extra output

    $data = json_decode(file_get_contents('php://input'), true);

    if (!$data || !isset($data['user_id'])) {
        echo json_encode(['success' => false, 'message' => 'User ID is missing', 'received_data' => $data]);
        exit;
    }

    $user_id = $data['user_id'];

    $stmt = $db->prepare("SELECT is_online, last_seen FROM users WHERE id = ?");
    $stmt->execute([$user_id]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        // ✅ Convert database value to Boolean
        $isOnline = (bool) $user['is_online']; 

        $status = $isOnline 
            ? "🟢 Online" 
            : "⏳ Last seen: " . date("d M Y, h:i A", strtotime($user['last_seen']));

        echo json_encode(['success' => true, 'is_online' => $isOnline, 'status' => $status]);
    } else {
        echo json_encode(['success' => false, 'message' => 'User not found']);
    }
    exit;
}



// Handle user search
function handleSearch($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $username = $data['username'];

    try {
        $stmt = $db->prepare("
            SELECT id, username, profile_icon, 
                   TIMESTAMPDIFF(MINUTE, last_active, NOW()) AS inactive_minutes 
            FROM users 
            WHERE username = ?
        ");
        $stmt->execute([$username]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            $isOnline = $user['inactive_minutes'] <= 5;

            echo json_encode([
                'success' => true,
                'username' => $user['username'],
                'profile_icon' => $user['profile_icon'],
                'id' => $user['id'],
                'is_online' => $isOnline
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'User not found']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Search failed: ' . $e->getMessage()]);
    }
}

// Handle sending messages
function handleSendMessage($db) {
    $senderId = $_POST['sender_id'];
    $receiverId = $_POST['receiver_id'];
    $message = $_POST['message'] ?? null;

    $attachment = null; // Initialize attachment variable
    if (!empty($_FILES['attachment']['name'])) {
        // Allowed file types
        $allowedExtensions = ['jpg', 'png', 'pdf', 'gif', 'mp4', 'mp3'];
        $fileExtension = strtolower(pathinfo($_FILES['attachment']['name'], PATHINFO_EXTENSION));

        if (in_array($fileExtension, $allowedExtensions)) {
        	$maxSize = 10 * 1024 * 1024; // 10 MB
if ($_FILES['attachment']['size'] > $maxSize) {
    echo json_encode(['success' => false, 'message' => 'File size exceeds 10MB limit']);
    return;
}

$filename = preg_replace("/[^a-zA-Z0-9\.\-_]/", "", basename($_FILES['attachment']['name']));
$filePath = $uploadDir . uniqid() . "_" . $filename;
            $uploadDir = "uploads/private/"; // Directory for uploaded files
     $filePath = $uploadDir . uniqid() . "_" . $filename;

            // Move uploaded file to the server directory
            if (move_uploaded_file($_FILES['attachment']['tmp_name'], $filePath)) {
                $attachment = $filePath; // Set the attachment path
            } else {
                echo json_encode(['success' => false, 'message' => 'Failed to upload attachment']);
                return;
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid file type']);
            return;
        }
    }

    try {
    	
$stmt = $db->prepare("SELECT id FROM blocked_friends WHERE (user_id = ? AND blocked_user_id = ?) OR (user_id = ? AND blocked_user_id = ?)");
        $stmt->execute([$senderId, $receiverId, $receiverId, $senderId]);
        $blocked = $stmt->fetch(PDO::FETCH_ASSOC);

       if ($blocked) {
            // Return a JSON response with the block message
            echo json_encode(["success" => false, "message" => "You are blocked or have blocked this user. Messages cannot be displayed."]);
            return;
        }
        
        // Insert the message into the database
        $stmt = $db->prepare("INSERT INTO messages (sender_id, receiver_id, message, attachment) VALUES (?, ?, ?, ?)");
        $stmt->execute([$senderId, $receiverId, $message, $attachment]);

        // Add a notification for the receiver
        $stmt = $db->prepare("INSERT INTO notifications (sender_id, receiver_id, message) VALUES (?, ?, ?)");
        $stmt->execute([$senderId, $receiverId, $message]);

        echo json_encode(['success' => true, 'message' => 'Message sent successfully']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to send message: ' . $e->getMessage()]);
    }
}

// Handle fetching messages
function handleFetchMessages($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $userId = $data['user_id'];
    $friendId = $data['friend_id'];

    try {
    	
$stmt = $db->prepare("SELECT id FROM blocked_friends WHERE (user_id = ? AND blocked_user_id = ?) OR (user_id = ? AND blocked_user_id = ?)");
        $stmt->execute([$userId, $friendId, $friendId, $userId]);
        $blocked = $stmt->fetch(PDO::FETCH_ASSOC);

     if ($blocked) {
            // Return a JSON response with the block message
            echo json_encode(["success" => false, "message" => "You are blocked or have blocked this user. Messages cannot be displayed."]);
            return;
        }
        
        // Get sender and receiver profile details
        $stmt = $db->prepare("SELECT username, profile_icon FROM users WHERE id = ?");
        $stmt->execute([$userId]);
        $currentUser = $stmt->fetch(PDO::FETCH_ASSOC);

        $stmt = $db->prepare("SELECT username, profile_icon FROM users WHERE id = ?");
        $stmt->execute([$friendId]);
        $friend = $stmt->fetch(PDO::FETCH_ASSOC);

        // Fetch messages between the two users
        $stmt = $db->prepare(" SELECT id, sender_id, message, attachment, timestamp 
            FROM messages 
            WHERE (sender_id = ? AND receiver_id = ?) 
               OR (sender_id = ? AND receiver_id = ?) 
            ORDER BY timestamp ASC
        ");
        $stmt->execute([$userId, $friendId, $friendId, $userId]);
        $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            'success' => true,
            'currentUser' => $currentUser,
            'friend' => $friend,
            'messages' => $messages
        ]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to fetch messages: ' . $e->getMessage()]);
    }
}

// Handle fetching notifications
function handleFetchNotifications($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $userId = $data['user_id'];

    try {
        $stmt = $db->prepare("
            SELECT n.sender_id, u.username, u.profile_icon, n.message 
            FROM notifications n
            JOIN users u ON n.sender_id = u.id
            WHERE n.receiver_id = ? AND n.is_read = 0
            ORDER BY n.created_at DESC
        ");
        $stmt->execute([$userId]);
        $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['success' => true, 'notifications' => $notifications]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to fetch notifications: ' . $e->getMessage()]);
    }
}

// Handle marking notifications as read
function handleMarkNotificationsRead($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $userId = $data['user_id'];
    $friendId = $data['friend_id'];

    try {
        $stmt = $db->prepare("
            UPDATE notifications 
            SET is_read = 1 
            WHERE receiver_id = ? AND sender_id = ?
        ");
        $stmt->execute([$userId, $friendId]);

        echo json_encode(['success' => true]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to mark notifications as read: ' . $e->getMessage()]);
    }
}
function handleTypingStatus($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $senderId = $data['sender_id'];
    $receiverId = $data['receiver_id'];
    $isTyping = $data['is_typing'];

    try {
        // Check if typing status already exists
        $stmt = $db->prepare("SELECT * FROM typing_status WHERE sender_id = ? AND receiver_id = ?");
        $stmt->execute([$senderId, $receiverId]);
        $existingRecord = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($existingRecord) {
            // Update the existing typing status
            $stmt = $db->prepare("UPDATE typing_status SET is_typing = ?, updated_at = NOW() WHERE sender_id = ? AND receiver_id = ?");
            $stmt->execute([$isTyping, $senderId, $receiverId]);
        } else {
            // Insert a new typing status record
            $stmt = $db->prepare("INSERT INTO typing_status (sender_id, receiver_id, is_typing, updated_at) VALUES (?, ?, ?, NOW())");
            $stmt->execute([$senderId, $receiverId, $isTyping]);
        }

        echo json_encode(['success' => true, 'message' => 'Typing status updated']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to update typing status: ' . $e->getMessage()]);
    }
}
function handleGetTypingStatus($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $userId = $data['user_id'];
    $friendId = $data['friend_id'];

    try {
        $stmt = $db->prepare("
            SELECT ts.is_typing, u.username 
            FROM typing_status ts
            JOIN users u ON ts.sender_id = u.id
            WHERE ts.sender_id = ? AND ts.receiver_id = ?
        ");
        $stmt->execute([$friendId, $userId]);
        $typingStatus = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($typingStatus) {
            echo json_encode([
                'success' => true,
                'is_typing' => $typingStatus['is_typing'],
                'username' => $typingStatus['username'] // Ensure username is included
            ]);
        } else {
            echo json_encode(['success' => true, 'is_typing' => false]);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to fetch typing status: ' . $e->getMessage()]);
    }
}
function createGroup($db) {
    // Validate required inputs
    if (empty($_POST['group_name']) || empty($_POST['group_privacy'])) {
        echo json_encode(['success' => false, 'message' => 'Group name and privacy are required']);
        exit;
    }

    $groupName = htmlspecialchars($_POST['group_name']);
    $groupDescription = htmlspecialchars($_POST['group_description'] ?? '');
    $groupPrivacy = $_POST['group_privacy'];
    $createdBy = $_POST['user_id']; // Validate user ID

    if (empty($createdBy)) {
        echo json_encode(['success' => false, 'message' => 'User ID is required.']);
        exit;
    }

    $groupIconPath = null;

    // Handle group icon upload if provided
    if (!empty($_FILES['group_icon']['name'])) {
        $uploadDir = 'uploads/groups/';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true); // Create directory if it doesn't exist
        }

        $iconName = time() . '_' . basename($_FILES['group_icon']['name']); // Unique file name
        $groupIconPath = $uploadDir . $iconName;
        if (!move_uploaded_file($_FILES['group_icon']['tmp_name'], $groupIconPath)) {
            echo json_encode(['success' => false, 'message' => 'Failed to upload group icon']);
            exit;
        }
    }
    $stmtCheck = $db->prepare("SELECT id FROM groups WHERE name = ? OR icon = ?");
    $stmtCheck->execute([$groupName, $groupIconPath]);
    
    if ($stmtCheck->rowCount() > 0) {
        echo json_encode(['success' => false, 'message' => 'Group name or icon already taken. Choose another.']);
        exit;
    }
    // Insert group into database
    try {
        $stmt = $db->prepare("INSERT INTO groups (name, description, privacy, icon, created_by) VALUES (?, ?, ?, ?, ?)");
        if ($stmt->execute([$groupName, $groupDescription, $groupPrivacy, $groupIconPath, $createdBy])) {
        	$groupId = $db->lastInsertId(); // Get the new group ID

// Auto join the user to their own group
$stmtJoin = $db->prepare("INSERT INTO group_members (group_id, user_id) VALUES (?, ?)");
$stmtJoin->execute([$groupId, $createdBy]);
            echo json_encode(['success' => true, 'message' => 'Group created successfully']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to create group']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
    exit;
}

function fetchPublicGroups($db) {
    // Check if database connection exists
    if (!$db) {
        echo json_encode(['success' => false, 'message' => 'Database connection not established.']);
        exit;
    }

    try {
        // SQL Query to fetch only public groups and their creators
        $query = "
            SELECT 
               g.id AS group_id,
                g.name AS group_name, 
                g.icon AS group_icon, 
                g.description AS group_description, 
                u.username AS creator_username, 
                u.profile_icon AS creator_icon,
           (SELECT COUNT(*) FROM group_likes WHERE group_id = g.id) AS likes
                
            FROM groups g
            JOIN users u ON g.created_by = u.id
            WHERE g.privacy = 'public' -- Only public groups
            ORDER BY g.created_at DESC";

        // Prepare the query
        $stmt = $db->prepare($query);

        // Execute the query
        $stmt->execute();

        // Check if query execution was successful
        if (!$stmt) {
            echo json_encode(['success' => false, 'message' => 'Query execution failed.']);
            exit;
        }

        // Process query results using PDO fetch method
        $groups = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) { // Use PDO fetch method
            $groups[] = $row;
        }

        // Return groups or empty message
        if (empty($groups)) {
            echo json_encode(['success' => false, 'message' => 'No public groups found.']);
        } else {
            echo json_encode(['success' => true, 'groups' => $groups]);
        }
    } catch (Exception $e) {
        // Handle unexpected errors
        echo json_encode(['success' => false, 'message' => 'An error occurred.', 'error' => $e->getMessage()]);
    }
}

function fetchUserGroups($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $userId = $data['user_id'] ?? null;

    if (!$userId) {
        echo json_encode(['success' => false, 'message' => 'User ID is required']);
        return;
    }

    try {
        $stmt = $db->prepare("SELECT id, name, description, icon, privacy, created_at 
                              FROM groups 
                              WHERE created_by = ?");
        $stmt->execute([$userId]);
        $groups = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if ($groups) {
            echo json_encode(['success' => true, 'groups' => $groups]);
        } else {
            echo json_encode(['success' => false, 'message' => 'No groups found']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to fetch user groups: ' . $e->getMessage()]);
    }
}

function handleJoinGroup($db) {
    // Parse raw JSON input
    $rawInput = json_decode(file_get_contents('php://input'), true);
    $userId = $rawInput['user_id'] ?? null;
    $groupName = $rawInput['group_name'] ?? null;

    try {
        $db->beginTransaction(); // ✅ Start transaction

        // ✅ Step 1: Check if group exists
        $checkGroupStmt = $db->prepare("SELECT id FROM groups WHERE name = :group_name");
        $checkGroupStmt->bindValue(':group_name', $groupName, PDO::PARAM_STR);
        $checkGroupStmt->execute();
        $group = $checkGroupStmt->fetch(PDO::FETCH_ASSOC);
        $checkGroupStmt->closeCursor(); // ✅ Free memory

        if (!$group) {
            $db->rollBack();
            echo json_encode(['success' => false, 'message' => 'Group does not exist.']);
            return;
        }

        $groupId = $group['id'];

        // ✅ Step 2: Check if the user is already in the group
        $checkMembershipStmt = $db->prepare("SELECT id FROM group_members WHERE group_id = :group_id AND user_id = :user_id");
        $checkMembershipStmt->bindValue(':group_id', $groupId, PDO::PARAM_INT);
        $checkMembershipStmt->bindValue(':user_id', $userId, PDO::PARAM_INT);
        $checkMembershipStmt->execute();
        $isMember = $checkMembershipStmt->fetch(PDO::FETCH_ASSOC);
        $checkMembershipStmt->closeCursor(); // ✅ Free memory

        if ($isMember) {
            $db->rollBack();
            echo json_encode(['success' => false, 'message' => 'you are already in the group.']);
            return;
        }

        // ✅ Step 3: Remove the invitation from `group_invites`
        $deleteInviteStmt = $db->prepare("DELETE FROM group_invites WHERE invitee_id = :user_id AND group_id = :group_id");
        $deleteInviteStmt->bindValue(':user_id', $userId, PDO::PARAM_INT);
        $deleteInviteStmt->bindValue(':group_id', $groupId, PDO::PARAM_INT);
        $deleteInviteStmt->execute();
        $deleteInviteStmt->closeCursor(); // ✅ Free memory

        // ✅ Step 4: Add the user to `group_members`
        $joinGroupStmt = $db->prepare("INSERT INTO group_members (group_id, user_id) VALUES (:group_id, :user_id)");
        $joinGroupStmt->bindValue(':group_id', $groupId, PDO::PARAM_INT);
        $joinGroupStmt->bindValue(':user_id', $userId, PDO::PARAM_INT);
        $joinGroupStmt->execute();
        $joinGroupStmt->closeCursor(); // ✅ Free memory

        $db->commit(); // ✅ Commit transaction

        echo json_encode(['success' => true, 'message' => 'Successfully joined the group.', 'group_id' => $groupId]);
    } catch (Exception $e) {
        $db->rollBack(); // ❌ Rollback on failure
        echo json_encode(['success' => false, 'message' => 'Failed to join the group.', 'error' => $e->getMessage()]);
    }
}

function fetchJoinedGroups($db) {
    $response = ['success' => false, 'groups' => [], 'message' => ''];

    // Check if input is JSON or form data
    $input = json_decode(file_get_contents('php://input'), true);
    $userId = $input['user_id'] ?? $_POST['user_id'] ?? null;

    try {
        // Fetch groups the user has joined, along with group and creator profile icons
        $stmt = $db->prepare("
            SELECT 
                g.id AS group_id,
                g.name AS group_name,
                g.description AS group_description,
                g.privacy AS group_privacy,
                g.icon AS group_icon,
                u.username AS creator_username,
                u.profile_icon AS creator_profile_icon
            FROM 
                group_members gm
            INNER JOIN 
                groups g ON gm.group_id = g.id
            INNER JOIN 
                users u ON g.created_by = u.id
            WHERE 
                gm.user_id = ?
        ");
        $stmt->execute([$userId]);

        $groups = $stmt->fetchAll(PDO::FETCH_ASSOC);
        if ($groups) {
            $response['success'] = true;
            $response['groups'] = $groups;
        }
    } catch (Exception $e) {
        $response['message'] = "Error fetching groups: " . $e->getMessage();
    }

    echo json_encode($response);
}

// Fetch group messages
function handleFetchGroupMessages($db) {
    $groupId = $_POST['group_id'] ?? json_decode(file_get_contents('php://input'), true)['group_id'];
$userId = $_POST['user_id'] ?? json_decode(file_get_contents('php://input'), true)['user_id'];

    if (!$groupId) {
        echo json_encode(['success' => false, 'message' => 'Group ID is required.']);
        return;
    }

try {
        // Check if the user is blocked
        $checkBlock = $db->prepare("SELECT * FROM blocked_users WHERE group_id = ? AND user_id = ?");
        $checkBlock->execute([$groupId, $userId]);

        if ($checkBlock->rowCount() > 0) {
            echo json_encode(['success' => false, 'message' => 'You are blocked from this chat.']);
            return;
        }

    $stmt = $db->prepare("
        SELECT 
            gm.id, 
            gm.message, 
            gm.sender_id, 
            u.username AS sender_username, 
            u.profile_icon AS sender_icon,
            g.created_by
        FROM group_messages gm
        JOIN users u ON gm.sender_id = u.id
      JOIN groups g ON gm.group_id = g.id
        WHERE gm.group_id = ?
        ORDER BY gm.created_at ASC
    ");
    $stmt->execute([$groupId]);

    $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode(['success' => true, 'messages' => $messages]);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
}

function handleSendGroupMessage($db) {
    $groupId = $_POST['group_id'] ?? json_decode(file_get_contents('php://input'), true)['group_id'];
    $userId = $_POST['user_id'] ?? json_decode(file_get_contents('php://input'), true)['user_id'];
    $message = $_POST['message'] ?? json_decode(file_get_contents('php://input'), true)['message'];

    if (!$groupId || !$userId || !$message) {
        echo json_encode(['success' => false, 'message' => 'Group ID, User ID, and Message are required.']);
        return;
    }
try {
        // Check if the user is blocked
        $checkBlock = $db->prepare("SELECT * FROM blocked_users WHERE group_id = ? AND user_id = ?");
        $checkBlock->execute([$groupId, $userId]);

        if ($checkBlock->rowCount() > 0) {
            echo json_encode(['success' => false, 'message' => 'You are blocked from this chat.']);
            return;
        }
    $stmt = $db->prepare("
        INSERT INTO group_messages (group_id, sender_id, message, created_at)
        VALUES (?, ?, ?, NOW())
    ");
    $stmt->execute([$groupId, $userId, $message]);

    if ($stmt->rowCount() > 0) {
        echo json_encode(['success' => true, 'message' => 'Message sent successfully.']);
    } else {
            echo json_encode(['success' => false, 'message' => 'Failed to send message.']);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
}

function fetchGroupUsers($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $groupId = $data['group_id'] ?? null;
    $userId = $data['user_id'] ?? null; // ✅ Get user ID

    if (!$groupId) {
        echo json_encode([
            'success' => false,
            'message' => 'Group ID is required.'
        ]);
        return;
    }

    try {
        // ✅ Fetch group creator
        $query = $db->prepare("
            SELECT u.username AS creator_username 
            FROM groups g
            JOIN users u ON g.created_by = u.id
            WHERE g.id = :group_id
        ");
        $query->bindParam(':group_id', $groupId, PDO::PARAM_INT);
        $query->execute();
        $creator = $query->fetch(PDO::FETCH_ASSOC);

        if (!$creator) {
            echo json_encode([
                'success' => false,
                'message' => 'Group creator not found.'
            ]);
            return;
        }

        // ✅ Fetch joined users
        $userQuery = $db->prepare("
            SELECT u.id, u.username, u.profile_icon
            FROM group_members gm
            JOIN users u ON gm.user_id = u.id
            WHERE gm.group_id = :group_id
        ");
        $userQuery->bindParam(':group_id', $groupId, PDO::PARAM_INT);
        $userQuery->execute();
        $users = $userQuery->fetchAll(PDO::FETCH_ASSOC); // ✅ Fetch as an array

        // ✅ Fetch like count
        $likeQuery = $db->prepare("SELECT COUNT(*) FROM group_likes WHERE group_id = :group_id");
        $likeQuery->bindParam(':group_id', $groupId, PDO::PARAM_INT);
        $likeQuery->execute();
        $likes = $likeQuery->fetchColumn() ?: 0;

        // ✅ Check if user has liked the group
        $liked = false;
        if (!empty($userId)) {
            $checkLikeQuery = $db->prepare("SELECT 1 FROM group_likes WHERE group_id = :group_id AND user_id = :user_id");
            $checkLikeQuery->bindParam(':group_id', $groupId, PDO::PARAM_INT);
            $checkLikeQuery->bindParam(':user_id', $userId, PDO::PARAM_INT);
            $checkLikeQuery->execute();
            $liked = $checkLikeQuery->fetchColumn() ? true : false;
        }

        // ✅ Send response with users, likes, and like status
        echo json_encode([
            'success' => true,
            'creator' => ['username' => $creator['creator_username']],
            'users' => $users, // ✅ Make sure this is included
            'likes' => $likes,
            'liked' => $liked
        ]);
    } catch (PDOException $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
}


function handleRemoveUser($db, $group_id, $user_id) {
    if (!$group_id || !$user_id) {
        echo json_encode([
            'success' => false,
            'message' => 'Group ID or User ID is missing.'
        ]);
        return;
    }

    try {
        // Attempt to delete the user from the group
        $query = "DELETE FROM group_members WHERE group_id = ? AND user_id = ?";
        $stmt = $db->prepare($query);

        if ($stmt->execute([$group_id, $user_id])) {
            echo json_encode([
                'success' => true,
                'message' => 'User removed successfully.',
                'group_id' => $group_id,   // Include group_id in the raw JSON
                'user_id' => $user_id      // Include user_id in the raw JSON
            ]);
        } else {
            echo json_encode([
                'success' => false,
                'message' => 'Failed to remove the user.',
                'group_id' => $group_id,
                'user_id' => $user_id,
                'debug' => $stmt->errorInfo() // Log error info for debugging
            ]);
        }
    } catch (Exception $e) {
        // In case of an error, log it
        echo json_encode([
            'success' => false,
            'message' => 'Error: ' . $e->getMessage(),
            'group_id' => $group_id,
            'user_id' => $user_id
        ]);
    }
}

function handleBlockUser($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $groupId = $data['group_id'] ?? null;
    $userId = $data['user_id'] ?? null;

    if (!$groupId || !$userId) {
        echo json_encode(['success' => false, 'message' => 'Group ID and User ID are required.']);
        return;
    }

    try {
        // Check if the user is already blocked
        $checkQuery = $db->prepare("SELECT * FROM blocked_users WHERE group_id = ? AND user_id = ?");
        $checkQuery->execute([$groupId, $userId]);

        if ($checkQuery->rowCount() > 0) {
            echo json_encode(['success' => false, 'message' => 'User is already blocked.']);
            return;
        }
        $stmt = $db->prepare("INSERT INTO blocked_users (group_id, user_id) VALUES (?, ?)");
        $stmt->execute([$groupId, $userId]);

        echo json_encode(['success' => true, 'message' => 'User blocked successfully.']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
}

function handleUnblockUser($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $groupId = $data['group_id'] ?? null;
    $userId = $data['user_id'] ?? null;

    if (!$groupId || !$userId) {
        echo json_encode(['success' => false, 'message' => 'Group ID and User ID required.']);
        return;
    }

    try {
        // Check if the user is already unblocked (not in blocked_users table)
        $checkQuery = $db->prepare("SELECT COUNT(*) FROM blocked_users WHERE group_id = ? AND user_id = ?");
        $checkQuery->execute([$groupId, $userId]);
        $isBlocked = $checkQuery->fetchColumn();

        if ($isBlocked == 0) {
            echo json_encode(['success' => false, 'message' => 'User is already unblocked.']);
            return;
        }

        // Proceed to unblock the user
        $stmt = $db->prepare("DELETE FROM blocked_users WHERE group_id = ? AND user_id = ?");
        $stmt->execute([$groupId, $userId]);

        echo json_encode(['success' => true, 'message' => 'User unblocked successfully.']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }
}

function fetchBlockedUsers($db) {
    // Decode JSON input
    $data = json_decode(file_get_contents('php://input'), true);

    // Extract values
    $groupId = $data['group_id'] ?? null;

    // Validate input
    if (!$groupId) {
        echo json_encode(['success' => false, 'message' => 'Group ID is required.']);
        return;
    }

    try {
        // Fetch blocked users and their details
        $stmt = $db->prepare("
            SELECT u.id AS user_id, u.username, u.profile_icon 
            FROM blocked_users b
            JOIN users u ON b.user_id = u.id
            WHERE b.group_id = ?
        ");
        $stmt->execute([$groupId]);
        $blockedUsers = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (empty($blockedUsers)) {
            echo json_encode(['success' => false, 'message' => 'No blocked users found.']);
        } else {
            echo json_encode(['success' => true, 'users' => $blockedUsers]);
        }
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
}

function handleLeaveGroup($db, $group_id, $user_id) {
    if (!$group_id || !$user_id) {
        echo json_encode(['success' => false, 'message' => 'Missing Group ID or User ID.']);
        return;
    }

    // Debugging: Check if user exists in the group
    $checkQuery = "SELECT * FROM group_members WHERE group_id = ? AND user_id = ?";
    $checkStmt = $db->prepare($checkQuery);
    $checkStmt->execute([$group_id, $user_id]);

    if ($checkStmt->rowCount() == 0) {
        echo json_encode(['success' => false, 'message' => 'User is not a member of this group.']);
        return;
    }

    // Proceed with deletion
    $stmt = $db->prepare("DELETE FROM group_members WHERE group_id = ? AND user_id = ?");
    $stmt->execute([$group_id, $user_id]);

    if ($stmt->rowCount() > 0) {
        echo json_encode(['success' => true, 'message' => 'You have left the group successfully.']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Database error: Could not delete user.']);
    }
}

function handleDeleteGroup($db) {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $data = json_decode(file_get_contents('php://input'), true);
    $group_id = $data['group_id'] ?? null;

    if (!$group_id) {
        echo json_encode(['success' => false, 'message' => 'Missing Group ID.']);
        return;
    }

    try {
        // Start transaction to keep operations atomic
        $db->beginTransaction();

        // Delete all members from the group
        $stmtMembers = $db->prepare("DELETE FROM group_members WHERE group_id = ?");
        $stmtMembers->execute([$group_id]);

        // Delete the group itself
        $stmtGroup = $db->prepare("DELETE FROM groups WHERE id = ?");
        $stmtGroup->execute([$group_id]);

        // Commit both deletions
        $db->commit();

        echo json_encode(['success' => true, 'message' => 'Group and all its members deleted successfully.']);
    } catch (Exception $e) {
        $db->rollBack();
        echo json_encode(['success' => false, 'message' => 'Error deleting group and members: ' . $e->getMessage()]);
    }
}


function handleEditMessage($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $messageId = $data['message_id'] ?? null;
    $newMessage = $data['new_message'] ?? null;

    if (!$messageId || !$newMessage) {
        echo json_encode(['success' => false, 'message' => 'Missing message ID or new message text']);
        return;
    }

    try {
        $stmt = $db->prepare("UPDATE messages SET message = ? WHERE id = ?");
        $stmt->execute([$newMessage, $messageId]);

        echo json_encode(['success' => true, 'message' => 'Message will updated in after 3 seconds!!']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to update message: ' . $e->getMessage()]);
    }
}

function handleDeleteMessage($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $messageId = $data['message_id'] ?? null;

    if (!$messageId) {
        echo json_encode(['success' => false, 'message' => 'Missing message ID']);
        return;
    }

    try {
        $stmt = $db->prepare("DELETE FROM messages WHERE id = ?");
        $stmt->execute([$messageId]);

        echo json_encode(['success' => true, 'message' => 'Message will deleted in after 3 Seconds!!']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to delete message: ' . $e->getMessage()]);
    }
}

function handleEditGroupMessage($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $messageId = $data['message_id'] ?? null;
    $newMessage = $data['new_message'] ?? null;

    if (!$messageId || !$newMessage) {
        echo json_encode(['success' => false, 'message' => 'Missing message ID or new message text']);
        return;
    }

    try {
        $stmt = $db->prepare("UPDATE group_messages SET message = ? WHERE id = ?");
        $stmt->execute([$newMessage, $messageId]);

        echo json_encode(['success' => true, 'message' => 'Message will updated in after 3 seconds!!']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to update message: ' . $e->getMessage()]);
    }
}


function handleDeleteGroupMessage($db) {
    $data = json_decode(file_get_contents('php://input'), true);
    $messageId = $data['message_id'] ?? null;

    if (!$messageId) {
        echo json_encode(['success' => false, 'message' => 'Missing message ID']);
        return;
    }

    try {
        $stmt = $db->prepare("DELETE FROM group_messages WHERE id = ?");
        $stmt->execute([$messageId]);

        echo json_encode(['success' => true, 'message' => 'Message will deleted in after 3 Seconds!!']);
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Failed to delete message: ' . $e->getMessage()]);
    }
}

function handleLikeGroup($db) {
    $data = json_decode(file_get_contents("php://input"), true);
    $user_id = $data['user_id'] ?? null;
    $group_id = $data['group_id'] ?? null;

    if (!$user_id || !$group_id) {
        echo json_encode(["success" => false, "message" => "Invalid user or group"]);
        exit;
    }

    try {
        // Check if the user already liked the group
        $stmt = $db->prepare("SELECT * FROM group_likes WHERE user_id = ? AND group_id = ?");
        $stmt->execute([$user_id, $group_id]);
        $existingLike = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($existingLike) {
            // Unlike (Remove like)
            $stmt = $db->prepare("DELETE FROM group_likes WHERE user_id = ? AND group_id = ?");
            $stmt->execute([$user_id, $group_id]);
        } else {
            // Like the group
            $stmt = $db->prepare("INSERT INTO group_likes (group_id, user_id) VALUES (?, ?)");
            $stmt->execute([$group_id, $user_id]);
        }

        // Get updated like count
        $stmt = $db->prepare("SELECT COUNT(*) AS likes FROM group_likes WHERE group_id = ?");
        $stmt->execute([$group_id]);
        $likes = $stmt->fetch(PDO::FETCH_ASSOC)['likes'];

        echo json_encode(["success" => true, "new_likes" => $likes]);
    } catch (PDOException $e) {
        echo json_encode(["success" => false, "message" => "Database error"]);
    }
}

?>
	