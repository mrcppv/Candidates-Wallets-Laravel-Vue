<template>
  <div>
    <div class="p-10">
      <h1 class="text-4xl font-bold">Candidates</h1>
    </div>
     <div class="p-10 grid grid-cols-1 sm:grid-cols-1 md:grid-cols-3 lg:grid-cols-3 xl:grid-cols-3 gap-5">
      <div v-for="candidate in candidates" :key="candidate.id" :class="{ 'hidden': shouldHideCandidate(candidate) }">
        <img alt="" class="w-full" src="/avatar.png">
        <div class="px-6 py-4">
          <div class="font-bold text-xl mb-2">{{ candidate.name }}</div>
          <p class="text-gray-700 text-base">{{ candidate.description }}</p>
        </div>
        <div class="px-6 pt-4 pb-2">
          <span
              v-for="strength in JSON.parse(candidate.strengths)"
              :class="desiredStrengths.includes(strength) ? 'bg-custom-green' : ''"
              class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2"
          >{{ strength }}</span>
        </div>
        <div class="px-6 pb-2">
          <span
              v-for="skill in JSON.parse(candidate.soft_skills)"
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
    candidates: Array
  },
  components: {
    MvpCandidates,
  },
  data() {
    return {
      desiredStrengths: ['Vue.js', 'Laravel', 'PHP', 'TailwindCSS'],
      desiredSkills: ['Diplomacy', 'Leadership']

    };
  },


  methods: {
    hireCandidate(candidateId) {
      axios.post(`/candidates-hire/${candidateId}`, {
        // You can pass additional data to the controller here, if needed.
      }).then(response => {
        alert(response.data.message);
        window.location.reload();
      });
    },
    contactCandidate(candidateId) {
      axios.post(`/candidates-contact/${candidateId}`, {
        // You can pass additional data to the controller here, if needed.
      }).then(response => {
        alert(response.data.message);
        window.location.reload();
      });
    },
    shouldHideCandidate(candidate) {
      // Check if the candidate has the "WordPress" skill
      return JSON.parse(candidate.strengths).includes('Wordpress');
    }
  }
}
</script>
