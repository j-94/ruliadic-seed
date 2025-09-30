// Ruliadic Evolution Engine - Chat-based system evolution and expansion
// This enables the seed to grow and adapt through conversation

(function(global) {
    'use strict';

    const EvolutionEngine = {
        version: '1.0.0',
        active: false,
        conversations: [],
        adaptations: [],
        expansions: [],

        // Initialize evolution engine
        init: function(seed) {
            console.log('🧬 Evolution Engine initializing...');
            this.seed = seed;
            this.active = true;

            // Set up conversation monitoring
            this.setupConversationMonitoring();

            // Initialize expansion triggers
            this.setupExpansionTriggers();

            console.log('✅ Evolution Engine active');
            return this;
        },

        setupConversationMonitoring: function() {
            // Monitor conversations for evolution triggers
            this.conversationPatterns = {
                growth: [
                    'grow', 'evolve', 'expand', 'develop', 'advance',
                    'level up', 'next stage', 'improve', 'enhance'
                ],
                adaptation: [
                    'adapt', 'adjust', 'modify', 'change', 'transform',
                    'customize', 'configure', 'optimize'
                ],
                generation: [
                    'generate', 'create', 'build', 'make', 'produce',
                    'canvas', 'interface', 'system', 'application'
                ],
                analysis: [
                    'analyze', 'examine', 'study', 'investigate', 'explore',
                    'status', 'info', 'details', 'metrics'
                ]
            };
        },

        setupExpansionTriggers: function() {
            // Define what triggers system expansion
            this.expansionTriggers = {
                conversation_count: 5,      // After 5 conversations
                capability_request: true,   // When new capability requested
                environment_change: true,   // When environment changes
                time_based: 30000,          // Every 30 seconds
                explicit_request: true      // When explicitly requested
            };
        },

        // Process conversation for evolution opportunities
        processConversation: function(message, response) {
            const conversation = {
                input: message,
                output: response,
                timestamp: new Date().toISOString(),
                patterns: this.analyzePatterns(message),
                evolution_potential: this.assessEvolutionPotential(message)
            };

            this.conversations.push(conversation);

            // Check for evolution triggers
            this.checkEvolutionTriggers(conversation);

            return conversation;
        },

        analyzePatterns: function(message) {
            const patterns = { detected: [], categories: {} };
            const lowerMessage = message.toLowerCase();

            // Check each pattern category
            Object.keys(this.conversationPatterns).forEach(category => {
                const categoryPatterns = this.conversationPatterns[category];
                const matches = categoryPatterns.filter(pattern =>
                    lowerMessage.includes(pattern)
                );

                if (matches.length > 0) {
                    patterns.detected.push(...matches);
                    patterns.categories[category] = matches;
                }
            });

            return patterns;
        },

        assessEvolutionPotential: function(message) {
            let potential = 0;

            // High potential indicators
            if (message.includes('?') || message.includes('how') || message.includes('what')) {
                potential += 2; // Information seeking
            }

            if (message.includes('create') || message.includes('generate') || message.includes('build')) {
                potential += 3; // Creation requests
            }

            if (message.includes('improve') || message.includes('enhance') || message.includes('optimize')) {
                potential += 2; // Improvement requests
            }

            if (message.includes('new') || message.includes('different') || message.includes('custom')) {
                potential += 1; // Novelty requests
            }

            // Length as complexity indicator
            if (message.length > 100) potential += 1;
            if (message.length > 200) potential += 1;

            return {
                score: potential,
                level: potential >= 5 ? 'high' : potential >= 3 ? 'medium' : 'low'
            };
        },

        checkEvolutionTriggers: function(conversation) {
            const triggers = [];

            // Conversation count trigger
            if (this.conversations.length >= this.expansionTriggers.conversation_count) {
                triggers.push('conversation_milestone');
            }

            // Pattern-based triggers
            if (conversation.patterns.categories.growth?.length > 0) {
                triggers.push('growth_requested');
            }

            if (conversation.patterns.categories.adaptation?.length > 0) {
                triggers.push('adaptation_requested');
            }

            if (conversation.patterns.categories.generation?.length > 0) {
                triggers.push('generation_requested');
            }

            // Process triggers
            triggers.forEach(trigger => {
                this.handleEvolutionTrigger(trigger, conversation);
            });
        },

        handleEvolutionTrigger: function(trigger, conversation) {
            console.log(`🎯 Evolution trigger: ${trigger}`);

            switch (trigger) {
                case 'conversation_milestone':
                    this.triggerConversationMilestone();
                    break;
                case 'growth_requested':
                    this.triggerGrowth(conversation);
                    break;
                case 'adaptation_requested':
                    this.triggerAdaptation(conversation);
                    break;
                case 'generation_requested':
                    this.triggerGeneration(conversation);
                    break;
            }
        },

        triggerConversationMilestone: function() {
            if (this.seed.state === 'seed') {
                console.log('🌱 Conversation milestone reached - triggering growth');
                this.seed.grow();

                this.expansions.push({
                    type: 'conversation_milestone',
                    from_state: 'seed',
                    to_state: 'sprout',
                    timestamp: new Date().toISOString(),
                    trigger: 'conversation_count'
                });
            }
        },

        triggerGrowth: function(conversation) {
            const growthPlan = this.planGrowth(conversation);

            if (growthPlan.execute) {
                this.executeGrowth(growthPlan);
            }
        },

        triggerAdaptation: function(conversation) {
            const adaptationPlan = this.planAdaptation(conversation);

            if (adaptationPlan.targets.length > 0) {
                this.executeAdaptation(adaptationPlan);
            }
        },

        triggerGeneration: function(conversation) {
            const generationPlan = this.planGeneration(conversation);

            if (generationPlan.outputs.length > 0) {
                this.executeGeneration(generationPlan);
            }
        },

        planGrowth: function(conversation) {
            const plan = {
                execute: false,
                targets: [],
                priority: 'medium'
            };

            // Analyze conversation for growth opportunities
            if (conversation.evolution_potential.level === 'high') {
                plan.execute = true;
                plan.priority = 'high';

                // Determine growth targets based on conversation
                if (conversation.patterns.categories.growth?.includes('create')) {
                    plan.targets.push('interface_enhancement');
                }

                if (conversation.patterns.categories.growth?.includes('improve')) {
                    plan.targets.push('capability_improvement');
                }

                if (conversation.patterns.categories.growth?.includes('expand')) {
                    plan.targets.push('feature_expansion');
                }
            }

            return plan;
        },

        planAdaptation: function(conversation) {
            const plan = {
                targets: [],
                environment: this.seed.environment.type,
                priority: 'medium'
            };

            // Extract adaptation targets from conversation
            const adaptationKeywords = conversation.patterns.categories.adaptation || [];

            if (adaptationKeywords.includes('adapt')) {
                plan.targets.push('browser_optimization');
            }

            if (adaptationKeywords.includes('mobile') || adaptationKeywords.includes('responsive')) {
                plan.targets.push('mobile_adaptation');
            }

            if (adaptationKeywords.includes('performance') || adaptationKeywords.includes('speed')) {
                plan.targets.push('performance_optimization');
            }

            return plan;
        },

        planGeneration: function(conversation) {
            const plan = {
                outputs: [],
                format: 'auto',
                complexity: 'medium'
            };

            // Determine what to generate based on conversation
            if (conversation.patterns.categories.generation?.includes('canvas')) {
                plan.outputs.push('ruliadic_canvas');
                plan.format = 'html';
            }

            if (conversation.patterns.categories.generation?.includes('interface')) {
                plan.outputs.push('interface_component');
                plan.format = 'html';
            }

            if (conversation.patterns.categories.generation?.includes('code')) {
                plan.outputs.push('code_snippet');
                plan.format = 'javascript';
            }

            return plan;
        },

        executeGrowth: function(plan) {
            console.log(`🚀 Executing growth plan: ${plan.targets.join(', ')}`);

            plan.targets.forEach(target => {
                switch (target) {
                    case 'interface_enhancement':
                        this.enhanceInterface();
                        break;
                    case 'capability_improvement':
                        this.improveCapabilities();
                        break;
                    case 'feature_expansion':
                        this.expandFeatures();
                        break;
                }
            });

            this.expansions.push({
                type: 'growth',
                targets: plan.targets,
                timestamp: new Date().toISOString(),
                priority: plan.priority
            });
        },

        executeAdaptation: function(plan) {
            console.log(`🔄 Executing adaptation plan for ${plan.environment}`);

            plan.targets.forEach(target => {
                this.seed.adapt(target.replace('_', ' '));
            });

            this.adaptations.push({
                type: 'adaptation',
                targets: plan.targets,
                environment: plan.environment,
                timestamp: new Date().toISOString()
            });
        },

        executeGeneration: function(plan) {
            console.log(`🎨 Executing generation plan`);

            plan.outputs.forEach(output => {
                const generated = this.generateOutput(output, plan);
                this.handleGeneratedOutput(output, generated);
            });
        },

        enhanceInterface: function() {
            // Enhance the interface based on usage patterns
            if (!this.seed.advanced) {
                this.seed.enableAdvancedFeatures();
            }

            // Add new interface elements
            this.addInterfaceEnhancements();
        },

        improveCapabilities: function() {
            // Improve existing capabilities
            Object.keys(this.seed.capabilities).forEach(cap => {
                this.seed.capabilities[cap].efficiency =
                    (this.seed.capabilities[cap].efficiency || 1) * 1.1;
            });
        },

        expandFeatures: function() {
            // Add new features based on conversation patterns
            if (!this.seed.expansion) {
                this.seed.expansion = {};
            }

            // Analyze conversation patterns for feature ideas
            const recentConversations = this.conversations.slice(-5);
            const featureIdeas = this.extractFeatureIdeas(recentConversations);

            featureIdeas.forEach(idea => {
                this.seed.expansion[idea] = {
                    available: true,
                    experimental: true,
                    description: `Auto-generated feature: ${idea}`
                };
            });
        },

        addInterfaceEnhancements: function() {
            // Add interface enhancements
            if (this.seed.environment.isBrowser) {
                this.addBrowserEnhancements();
            } else if (this.seed.environment.isNode) {
                this.addNodeEnhancements();
            }
        },

        addBrowserEnhancements: function() {
            // Add browser-specific enhancements
            const enhancements = [
                'keyboard_shortcuts',
                'context_menus',
                'drag_drop',
                'real_time_collaboration'
            ];

            enhancements.forEach(enhancement => {
                if (!this.seed.interface[enhancement]) {
                    this.seed.interface[enhancement] = true;
                    console.log(`✨ Added browser enhancement: ${enhancement}`);
                }
            });
        },

        addNodeEnhancements: function() {
            // Add Node.js-specific enhancements
            const enhancements = [
                'file_watching',
                'process_monitoring',
                'module_hot_reloading',
                'cluster_support'
            ];

            enhancements.forEach(enhancement => {
                if (!this.seed.interface[enhancement]) {
                    this.seed.interface[enhancement] = true;
                    console.log(`⚙️ Added Node.js enhancement: ${enhancement}`);
                }
            });
        },

        extractFeatureIdeas: function(conversations) {
            const ideas = [];

            conversations.forEach(conv => {
                // Extract nouns and adjectives as feature ideas
                const words = conv.input.split(' ');
                words.forEach(word => {
                    if (word.length > 6 && !ideas.includes(word.toLowerCase())) {
                        ideas.push(word.toLowerCase());
                    }
                });
            });

            return ideas.slice(0, 3); // Limit to 3 ideas
        },

        generateOutput: function(type, plan) {
            const generators = {
                ruliadic_canvas: () => this.generateRuliadicCanvas(plan),
                interface_component: () => this.generateInterfaceComponent(plan),
                code_snippet: () => this.generateCodeSnippet(plan)
            };

            return generators[type] ? generators[type]() : { type, generated: true };
        },

        generateRuliadicCanvas: function(plan) {
            return {
                type: 'ruliadic_canvas',
                environment: this.seed.environment.type,
                features: Object.keys(this.seed.capabilities),
                evolution_stage: this.seed.state,
                generated_by: 'evolution_engine',
                timestamp: new Date().toISOString()
            };
        },

        generateInterfaceComponent: function(plan) {
            return {
                type: 'interface_component',
                framework: this.detectFramework(),
                capabilities: Object.keys(this.seed.capabilities),
                responsive: true,
                accessible: true,
                timestamp: new Date().toISOString()
            };
        },

        generateCodeSnippet: function(plan) {
            return {
                type: 'code_snippet',
                language: plan.format,
                environment: this.seed.environment.type,
                capabilities: Object.keys(this.seed.capabilities),
                snippet: `// Generated by Ruliadic Evolution Engine\nconsole.log('Evolved capability: ${Object.keys(this.seed.capabilities)[0]}');`,
                timestamp: new Date().toISOString()
            };
        },

        detectFramework: function() {
            if (this.seed.environment.hasReact) return 'react';
            if (this.seed.environment.hasVue) return 'vue';
            if (this.seed.environment.hasAngular) return 'angular';
            return 'vanilla';
        },

        handleGeneratedOutput: function(type, output) {
            console.log(`📦 Generated ${type}:`, output);

            // Store in evolution history
            this.expansions.push({
                type: 'generation',
                output_type: type,
                output,
                timestamp: new Date().toISOString()
            });

            // Make available globally
            if (global.window) {
                global.window[`generated_${type}`] = output;
            }
        },

        // Chat-based evolution interface
        chat: function(message) {
            // Process through seed first
            const seedResponse = this.seed.chat(message);

            // Then process for evolution
            const evolutionResponse = this.processConversation(message, seedResponse.response);

            // Combine responses
            return {
                seed_response: seedResponse,
                evolution_analysis: evolutionResponse,
                combined_response: this.combineResponses(seedResponse, evolutionResponse)
            };
        },

        combineResponses: function(seedResponse, evolutionResponse) {
            let combined = seedResponse.response;

            // Add evolution insights if significant
            if (evolutionResponse.evolution_potential.level === 'high') {
                combined += `\n\n🤔 *Evolution Analysis:* I detect high potential for system growth in this conversation. The interface is learning and adapting based on your requests.`;
            }

            // Add capability hints
            if (this.seed.state !== 'seed') {
                combined += `\n\n💡 *System Status:* Currently in ${this.seed.state} stage with ${Object.keys(this.seed.capabilities).length} active capabilities.`;
            }

            return combined;
        },

        // Get evolution status
        getEvolutionStatus: function() {
            return {
                active: this.active,
                conversations_processed: this.conversations.length,
                adaptations_made: this.adaptations.length,
                expansions_performed: this.expansions.length,
                current_stage: this.seed.state,
                next_milestones: this.getNextMilestones()
            };
        },

        getNextMilestones: function() {
            const milestones = [];

            if (this.conversations.length < 5) {
                milestones.push(`Conversation milestone: ${5 - this.conversations.length} more conversations`);
            }

            if (this.seed.state === 'seed') {
                milestones.push('Growth to sprout stage');
            }

            if (this.seed.state === 'sprout') {
                milestones.push('Evolution to plant stage');
            }

            if (this.seed.state === 'plant') {
                milestones.push('Maturation to tree stage');
            }

            return milestones;
        },

        // Force evolution (for testing)
        forceEvolution: function(targetStage) {
            console.log(`🔧 Force evolution to: ${targetStage}`);

            const stages = ['seed', 'sprout', 'plant', 'tree'];
            const currentIndex = stages.indexOf(this.seed.state);
            const targetIndex = stages.indexOf(targetStage);

            if (targetIndex > currentIndex) {
                for (let i = currentIndex + 1; i <= targetIndex; i++) {
                    this.seed.grow();
                }

                this.expansions.push({
                    type: 'forced_evolution',
                    target: targetStage,
                    timestamp: new Date().toISOString()
                });

                return true;
            }

            return false;
        },

        // Export evolution data
        exportEvolution: function() {
            return {
                version: this.version,
                seed_state: this.seed.state,
                conversations: this.conversations,
                adaptations: this.adaptations,
                expansions: this.expansions,
                summary: this.getEvolutionStatus(),
                export_timestamp: new Date().toISOString()
            };
        }
    };

    // Auto-initialize if seed is available
    if (typeof global.RuliadicSeed !== 'undefined') {
        EvolutionEngine.init(global.RuliadicSeed);

        // Monkey patch seed chat method to include evolution
        const originalChat = global.RuliadicSeed.chat;
        global.RuliadicSeed.chat = function(message) {
            const seedResponse = originalChat.call(this, message);
            const evolutionResponse = EvolutionEngine.processConversation(message, seedResponse.response);
            return EvolutionEngine.combineResponses(seedResponse, evolutionResponse);
        };

        console.log('🧬 Evolution Engine integrated with Ruliadic Seed');
    }

    // Export for use
    if (typeof module !== 'undefined' && module.exports) {
        module.exports = EvolutionEngine;
    }

    if (global.window) {
        global.window.EvolutionEngine = EvolutionEngine;
    }

})(typeof globalThis !== 'undefined' ? globalThis : this);