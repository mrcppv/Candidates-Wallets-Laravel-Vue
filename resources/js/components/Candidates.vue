<template>
  <div>
    <div class="p-10">
      <h1 class="text-4xl font-bold">Candidates</h1>
      <div v-if="coins"><h1 class="text-4xl font-bold">Coins: {{ coins }}</h1></div>
    </div>
    <div class="p-10 grid grid-cols-1 sm:grid-cols-1 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-3 gap-5">
      <div v-for="candidate in candidates" :key="candidate.id" :class="{ 'hidden': shouldHideCandidate(candidate) }">
        <img alt="" class="w-full" src="/avatar.png">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">{{ candidate.name }}</div>
          <p class="text-gray-700 text-base">{{ candidate.description }}</p>
        </div>
        <div class="px-6 pt-4 pb-2">
          <span v-for="strength in JSON.parse(candidate.strengths)"
                :class="desiredStrengths.includes(strength) ? 'bg-custom-green' : ''"
                class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2"
          >{{ strength }}</span>
        </div>
        <div class="px-6 pb-2">
          <span v-for="skill in JSON.parse(candidate.soft_skills)"
                :class="desiredSkills.includes(skill) ? 'bg-custom-green' : ''"
                class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2"
          >{{ skill }}</span>
        </div>
        <div class="p-6 float-right">
          <button
              class="bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow"
              @click="contactCandidate(candidate.id)"
          >Contact</button>
          <button
              class="bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 hover:bg-teal-100 rounded shadow"
              @click="hireCandidate(candidate.id)"
          >Hire</button>
        </div>
      </div>
    </div>
    <MvpCandidates />
  </div>
</template>

<script>
import axios from 'axios';
import MvpCandidates from './MvpCandidates.vue';

export default {
  name: 'CandidateList',
  props: {
    candidates: Array,
    initialCoins: Number, // Added prop for initial coins value
    // coins: Number,
  },
  components: {
    MvpCandidates,
  },
  data() {
    return {
      desiredStrengths: ['Vue.js', 'Laravel', 'PHP', 'TailwindCSS'],
      desiredSkills: ['Diplomacy', 'Leadership'],
      coins: 0,
      //  coins: this.coins // Initialize coins with the prop value
    };
  },
  mounted() {

    this.fetchCoins(); // Fetch coins when the component is mounted


  },
  methods: {
    hireCandidate(candidateId) {
      axios.post(`/candidates-hire/${candidateId}`)
          .then(response => {
            const message = response.data.message;
            const coins = response.data.coins; // Assuming 'coins' is returned from the server
            alert(message); // Display success message
            this.coins = coins; // Update coins in the component

          })
          .catch(error => {
            console.error('Error hiring candidate:', error);
            alert('An error occurred while hiring the candidate.');


          });
    },
    contactCandidate(candidateId) {
      axios.post(`/candidates-contact/${candidateId}`)
          .then(response => {
            alert(response.data.message);
            // No need to reload the window
          });
    },
    shouldHideCandidate(candidate) {
      // Check if the candidate has the "WordPress" skill
      return JSON.parse(candidate.strengths).includes('Wordpress');
    },

    flashMessage(message) {
      // Implement your flash message logic here
      alert(message); // Simple alert for demonstration; use a better UI component in production
    },

    fetchCoins() {
      axios.get('/coins')
          .then(response => {
            console.log(response.data); // Log the response data to verify the format
            this.coins = response.data.coins; // Update coins value in the component
          })
          .catch(error => {
            console.error('Error fetching coins:', error);
            // Handle error
          });
    }


  }
}
</script>

<style>
/* Your styles here */
</style>
