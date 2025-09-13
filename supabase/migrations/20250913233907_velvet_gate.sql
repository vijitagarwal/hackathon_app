-- Seed data for Holistic University Platform
-- This script creates demo accounts and sample data for testing

-- Insert demo users (passwords will be handled by Supabase Auth)
-- Note: In production, these would be created through the auth system

-- Demo users data (to be inserted after auth users are created)
INSERT INTO users (id, email, full_name, role, department, student_id, teacher_id, year, subjects, hostel_room, phone) VALUES
-- Admin user
('00000000-0000-0000-0000-000000000001', 'admin@uni.test', 'System Administrator', 'admin', 'Administration', NULL, NULL, NULL, NULL, NULL, '+1234567890'),

-- Teachers
('00000000-0000-0000-0000-000000000002', 'teacher1@uni.test', 'Dr. Sarah Johnson', 'teacher', 'Computer Science', NULL, 'T001', NULL, ARRAY['Data Structures', 'Algorithms', 'Database Systems'], NULL, '+1234567891'),
('00000000-0000-0000-0000-000000000003', 'teacher2@uni.test', 'Prof. Michael Chen', 'teacher', 'Mathematics', NULL, 'T002', NULL, ARRAY['Calculus', 'Linear Algebra', 'Statistics'], NULL, '+1234567892'),
('00000000-0000-0000-0000-000000000004', 'teacher3@uni.test', 'Dr. Emily Rodriguez', 'teacher', 'Physics', NULL, 'T003', NULL, ARRAY['Quantum Physics', 'Thermodynamics'], NULL, '+1234567893'),

-- Students
('00000000-0000-0000-0000-000000000005', 'student1@uni.test', 'Alex Thompson', 'student', 'Computer Science', 'CS2021001', NULL, 3, NULL, 'H1-201', '+1234567894'),
('00000000-0000-0000-0000-000000000006', 'student2@uni.test', 'Maria Garcia', 'student', 'Computer Science', 'CS2021002', NULL, 3, NULL, 'H1-202', '+1234567895'),
('00000000-0000-0000-0000-000000000007', 'student3@uni.test', 'James Wilson', 'student', 'Mathematics', 'MA2021001', NULL, 2, NULL, 'H2-101', '+1234567896'),
('00000000-0000-0000-0000-000000000008', 'student4@uni.test', 'Lisa Anderson', 'student', 'Physics', 'PH2021001', NULL, 2, NULL, 'H2-102', '+1234567897'),
('00000000-0000-0000-0000-000000000009', 'student5@uni.test', 'David Kim', 'student', 'Computer Science', 'CS2022001', NULL, 2, NULL, 'H1-301', '+1234567898'),
('00000000-0000-0000-0000-000000000010', 'student6@uni.test', 'Sophie Brown', 'student', 'Mathematics', 'MA2022001', NULL, 1, NULL, 'H2-201', '+1234567899'),
('00000000-0000-0000-0000-000000000011', 'student7@uni.test', 'Ryan Davis', 'student', 'Physics', 'PH2022001', NULL, 1, NULL, 'H3-101', '+1234567800'),
('00000000-0000-0000-0000-000000000012', 'student8@uni.test', 'Emma Taylor', 'student', 'Computer Science', 'CS2023001', NULL, 1, NULL, 'H1-401', '+1234567801'),
('00000000-0000-0000-0000-000000000013', 'student9@uni.test', 'Noah Martinez', 'student', 'Mathematics', 'MA2023001', NULL, 1, NULL, 'H2-301', '+1234567802'),
('00000000-0000-0000-0000-000000000014', 'student10@uni.test', 'Olivia Johnson', 'student', 'Physics', 'PH2023001', NULL, 1, NULL, 'H3-201', '+1234567803'),

-- Warden
('00000000-0000-0000-0000-000000000015', 'warden@uni.test', 'Robert Smith', 'warden', 'Student Affairs', NULL, NULL, NULL, NULL, NULL, '+1234567804'),

-- Vendor
('00000000-0000-0000-0000-000000000016', 'vendor@uni.test', 'Cafe Manager', 'vendor', 'Food Services', NULL, NULL, NULL, NULL, NULL, '+1234567805')

ON CONFLICT (id) DO NOTHING;

-- Sample resources
INSERT INTO resources (id, title, description, file_url, file_type, file_size, uploaded_by, ai_summary, tags, department, subject, is_public) VALUES
('10000000-0000-0000-0000-000000000001', 'Introduction to Data Structures', 'Comprehensive guide to fundamental data structures including arrays, linked lists, stacks, and queues.', '/uploads/data-structures-intro.pdf', 'application/pdf', 2048576, '00000000-0000-0000-0000-000000000002', '• Covers fundamental data structures like arrays, linked lists, stacks, and queues with practical examples\n• Explains time and space complexity analysis for each data structure operation\n• Includes implementation details in multiple programming languages with best practices', ARRAY['data-structures', 'algorithms', 'programming'], 'Computer Science', 'Data Structures', true),

('10000000-0000-0000-0000-000000000002', 'Advanced Algorithms Lecture Notes', 'Detailed notes on sorting algorithms, graph algorithms, and dynamic programming techniques.', '/uploads/advanced-algorithms.pdf', 'application/pdf', 3145728, '00000000-0000-0000-0000-000000000002', '• Comprehensive coverage of advanced sorting algorithms including merge sort, quick sort, and heap sort\n• Detailed explanation of graph algorithms such as DFS, BFS, Dijkstra, and minimum spanning trees\n• In-depth analysis of dynamic programming techniques with real-world problem-solving examples', ARRAY['algorithms', 'sorting', 'graphs', 'dynamic-programming'], 'Computer Science', 'Algorithms', true),

('10000000-0000-0000-0000-000000000003', 'Database Design Principles', 'Essential concepts of database design, normalization, and SQL optimization.', '/uploads/database-design.pdf', 'application/pdf', 1572864, '00000000-0000-0000-0000-000000000002', '• Explains fundamental database design principles including entity-relationship modeling and schema design\n• Covers normalization techniques from 1NF to BCNF with practical examples and benefits\n• Provides SQL optimization strategies and indexing techniques for improved query performance', ARRAY['database', 'sql', 'normalization', 'design'], 'Computer Science', 'Database Systems', true),

('10000000-0000-0000-0000-000000000004', 'Calculus Fundamentals', 'Basic calculus concepts including limits, derivatives, and integrals with solved examples.', '/uploads/calculus-fundamentals.pdf', 'application/pdf', 2621440, '00000000-0000-0000-0000-000000000003', '• Introduction to limits and continuity with graphical interpretations and practical applications\n• Comprehensive coverage of derivatives including rules, applications, and optimization problems\n• Detailed explanation of integrals, integration techniques, and applications in area and volume calculations', ARRAY['calculus', 'mathematics', 'derivatives', 'integrals'], 'Mathematics', 'Calculus', true),

('10000000-0000-0000-0000-000000000005', 'Quantum Physics Introduction', 'Introduction to quantum mechanics principles and wave-particle duality.', '/uploads/quantum-physics-intro.pdf', 'application/pdf', 4194304, '00000000-0000-0000-0000-000000000004', '• Introduces fundamental quantum mechanics principles including wave-particle duality and uncertainty principle\n• Explains quantum states, superposition, and measurement with mathematical formulations\n• Covers practical applications in modern technology including lasers, semiconductors, and quantum computing', ARRAY['quantum', 'physics', 'mechanics', 'wave-particle'], 'Physics', 'Quantum Physics', true)

ON CONFLICT (id) DO NOTHING;

-- Sample assignments
INSERT INTO assignments (id, title, description, due_date, created_by, max_marks, subject, department, is_published) VALUES
('20000000-0000-0000-0000-000000000001', 'Binary Search Tree Implementation', 'Implement a binary search tree with insert, delete, and search operations. Include time complexity analysis.', '2024-02-15 23:59:59+00', '00000000-0000-0000-0000-000000000002', 100, 'Data Structures', 'Computer Science', true),

('20000000-0000-0000-0000-000000000002', 'Sorting Algorithm Comparison', 'Compare the performance of different sorting algorithms (bubble, merge, quick sort) with empirical analysis.', '2024-02-20 23:59:59+00', '00000000-0000-0000-0000-000000000002', 100, 'Algorithms', 'Computer Science', true),

('20000000-0000-0000-0000-000000000003', 'Database Normalization Exercise', 'Normalize a given database schema to 3NF and explain the process step by step.', '2024-02-25 23:59:59+00', '00000000-0000-0000-0000-000000000002', 80, 'Database Systems', 'Computer Science', true),

('20000000-0000-0000-0000-000000000004', 'Calculus Problem Set 1', 'Solve the given calculus problems involving limits, derivatives, and optimization.', '2024-02-18 23:59:59+00', '00000000-0000-0000-0000-000000000003', 100, 'Calculus', 'Mathematics', true),

('20000000-0000-0000-0000-000000000005', 'Quantum Mechanics Problem Set', 'Solve problems related to wave functions, probability distributions, and quantum states.', '2024-02-22 23:59:59+00', '00000000-0000-0000-0000-000000000004', 100, 'Quantum Physics', 'Physics', true)

ON CONFLICT (id) DO NOTHING;

-- Sample assignment submissions
INSERT INTO assignment_submissions (id, assignment_id, student_id, submission_text, submitted_at, marks, feedback, graded_by, graded_at, status) VALUES
('30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'Implemented BST with all required operations. Time complexity: O(log n) average case.', '2024-02-14 18:30:00+00', 95, 'Excellent implementation with proper error handling. Good analysis of time complexity.', '00000000-0000-0000-0000-000000000002', '2024-02-16 10:00:00+00', 'graded'),

('30000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 'Compared bubble sort, merge sort, and quick sort with performance graphs and analysis.', '2024-02-19 20:15:00+00', 88, 'Good comparison and analysis. Could improve on explaining worst-case scenarios.', '00000000-0000-0000-0000-000000000002', '2024-02-21 14:30:00+00', 'graded'),

('30000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000007', 'Solved all calculus problems with detailed step-by-step solutions.', '2024-02-17 16:45:00+00', 92, 'Very good work. Clear explanations and correct solutions.', '00000000-0000-0000-0000-000000000003', '2024-02-19 11:20:00+00', 'graded')

ON CONFLICT (id) DO NOTHING;

-- Sample leave applications
INSERT INTO leave_applications (id, student_id, reason, from_date, to_date, status, applied_at, emergency_contact) VALUES
('40000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'Family wedding ceremony', '2024-02-10', '2024-02-12', 'approved', '2024-02-05 09:00:00+00', '+1234567999'),

('40000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 'Medical appointment', '2024-02-15', '2024-02-15', 'pending', '2024-02-12 14:30:00+00', '+1234567888'),

('40000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000007', 'Home visit for festival', '2024-02-20', '2024-02-22', 'pending', '2024-02-14 11:15:00+00', '+1234567777')

ON CONFLICT (id) DO NOTHING;

-- Sample meal menus
INSERT INTO meal_menus (id, date, meal_type, items, price, available, created_by) VALUES
('50000000-0000-0000-0000-000000000001', '2024-02-15', 'breakfast', ARRAY['Scrambled Eggs', 'Toast', 'Orange Juice', 'Coffee'], 8.50, true, '00000000-0000-0000-0000-000000000016'),
('50000000-0000-0000-0000-000000000002', '2024-02-15', 'lunch', ARRAY['Grilled Chicken', 'Rice', 'Vegetables', 'Salad', 'Fruit'], 12.00, true, '00000000-0000-0000-0000-000000000016'),
('50000000-0000-0000-0000-000000000003', '2024-02-15', 'dinner', ARRAY['Pasta', 'Garlic Bread', 'Caesar Salad', 'Ice Cream'], 10.50, true, '00000000-0000-0000-0000-000000000016'),

('50000000-0000-0000-0000-000000000004', '2024-02-16', 'breakfast', ARRAY['Pancakes', 'Maple Syrup', 'Fresh Berries', 'Milk'], 9.00, true, '00000000-0000-0000-0000-000000000016'),
('50000000-0000-0000-0000-000000000005', '2024-02-16', 'lunch', ARRAY['Fish Curry', 'Basmati Rice', 'Naan', 'Yogurt', 'Pickle'], 13.50, true, '00000000-0000-0000-0000-000000000016'),
('50000000-0000-0000-0000-000000000006', '2024-02-16', 'dinner', ARRAY['Vegetable Stir Fry', 'Fried Rice', 'Spring Rolls', 'Green Tea'], 11.00, true, '00000000-0000-0000-0000-000000000016'),

('50000000-0000-0000-0000-000000000007', '2024-02-17', 'breakfast', ARRAY['Oatmeal', 'Banana', 'Honey', 'Orange Juice'], 7.50, true, '00000000-0000-0000-0000-000000000016'),
('50000000-0000-0000-0000-000000000008', '2024-02-17', 'lunch', ARRAY['Burger', 'French Fries', 'Coleslaw', 'Soda'], 11.50, true, '00000000-0000-0000-0000-000000000016'),
('50000000-0000-0000-0000-000000000009', '2024-02-17', 'dinner', ARRAY['Grilled Salmon', 'Quinoa', 'Steamed Broccoli', 'Lemon Water'], 14.00, true, '00000000-0000-0000-0000-000000000016')

ON CONFLICT (id) DO NOTHING;

-- Sample meal bookings
INSERT INTO meal_bookings (id, student_id, menu_id, booking_date, meal_type, status, payment_status) VALUES
('60000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', '50000000-0000-0000-0000-000000000001', '2024-02-15', 'breakfast', 'booked', 'paid'),
('60000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000005', '50000000-0000-0000-0000-000000000002', '2024-02-15', 'lunch', 'booked', 'paid'),
('60000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000006', '50000000-0000-0000-0000-000000000001', '2024-02-15', 'breakfast', 'cancelled', 'refunded'),
('60000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000007', '50000000-0000-0000-0000-000000000004', '2024-02-16', 'breakfast', 'booked', 'paid'),
('60000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000008', '50000000-0000-0000-0000-000000000005', '2024-02-16', 'lunch', 'booked', 'pending')

ON CONFLICT (id) DO NOTHING;

-- Sample events
INSERT INTO events (id, title, description, event_date, location, max_participants, created_by, status, category) VALUES
('70000000-0000-0000-0000-000000000001', 'Annual Tech Symposium', 'A day-long symposium featuring talks from industry experts on emerging technologies.', '2024-03-15 09:00:00+00', 'Main Auditorium', 200, '00000000-0000-0000-0000-000000000002', 'approved', 'technical'),

('70000000-0000-0000-0000-000000000002', 'Cultural Night 2024', 'Showcase of diverse cultural performances by students from different backgrounds.', '2024-03-20 18:00:00+00', 'University Grounds', 500, '00000000-0000-0000-0000-000000000005', 'pending', 'cultural'),

('70000000-0000-0000-0000-000000000003', 'Mathematics Olympiad', 'Inter-departmental mathematics competition for all students.', '2024-03-10 14:00:00+00', 'Mathematics Building', 50, '00000000-0000-0000-0000-000000000003', 'approved', 'academic'),

('70000000-0000-0000-0000-000000000004', 'Basketball Tournament', 'Annual inter-hostel basketball championship.', '2024-03-25 16:00:00+00', 'Sports Complex', 100, '00000000-0000-0000-0000-000000000007', 'approved', 'sports')

ON CONFLICT (id) DO NOTHING;

-- Sample event registrations
INSERT INTO event_registrations (id, event_id, user_id, status) VALUES
('80000000-0000-0000-0000-000000000001', '70000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'registered'),
('80000000-0000-0000-0000-000000000002', '70000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000006', 'registered'),
('80000000-0000-0000-0000-000000000003', '70000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000007', 'registered'),
('80000000-0000-0000-0000-000000000004', '70000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000008', 'registered')

ON CONFLICT (id) DO NOTHING;

-- Sample chat messages
INSERT INTO chat_messages (id, user_id, message, response, sources) VALUES
('90000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'What are the key concepts in data structures?', 'Based on the uploaded resources, key concepts in data structures include:\n\n1. **Arrays and Linked Lists**: Fundamental linear data structures with different memory allocation patterns\n2. **Stacks and Queues**: LIFO and FIFO data structures used for specific algorithmic patterns\n3. **Trees and Graphs**: Hierarchical and network-based structures for complex data relationships\n4. **Time and Space Complexity**: Analysis of algorithm efficiency using Big O notation\n\nThese concepts form the foundation for understanding how data is organized and manipulated in computer programs.', ARRAY['Introduction to Data Structures']),

('90000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 'How do I approach database normalization?', 'Database normalization is a systematic approach to organizing data efficiently. Based on the course materials:\n\n1. **First Normal Form (1NF)**: Eliminate repeating groups and ensure atomic values\n2. **Second Normal Form (2NF)**: Remove partial dependencies on composite keys\n3. **Third Normal Form (3NF)**: Eliminate transitive dependencies\n\n**Step-by-step approach**:\n- Identify functional dependencies\n- Apply normalization rules progressively\n- Verify each normal form before proceeding\n- Balance normalization with query performance needs', ARRAY['Database Design Principles'])

ON CONFLICT (id) DO NOTHING;

-- Sample attendance records
INSERT INTO attendance (id, student_id, subject, date, status, marked_by) VALUES
('a0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'Data Structures', '2024-02-12', 'present', '00000000-0000-0000-0000-000000000002'),
('a0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 'Data Structures', '2024-02-12', 'present', '00000000-0000-0000-0000-000000000002'),
('a0000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000007', 'Calculus', '2024-02-12', 'absent', '00000000-0000-0000-0000-000000000003'),
('a0000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000008', 'Quantum Physics', '2024-02-12', 'late', '00000000-0000-0000-0000-000000000004'),
('a0000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000005', 'Algorithms', '2024-02-13', 'present', '00000000-0000-0000-0000-000000000002')

ON CONFLICT (id) DO NOTHING;

-- Sample grievances
INSERT INTO grievances (id, student_id, title, description, category, status, priority) VALUES
('b0000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000005', 'WiFi connectivity issues in hostel', 'The WiFi connection in H1 block is very slow and frequently disconnects, affecting online classes and assignments.', 'hostel', 'open', 'high'),

('b0000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000006', 'Food quality concerns', 'The food quality in the mess has deteriorated recently. Several students have complained about taste and hygiene.', 'mess', 'in_progress', 'medium'),

('b0000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000007', 'Library book shortage', 'Many required textbooks are not available in the library, making it difficult to complete assignments.', 'academic', 'open', 'medium')

ON CONFLICT (id) DO NOTHING;